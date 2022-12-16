class PlateContentGeneratorService < ApplicationService
  attr_reader :plate
  def initialize(params)
    @plate_size = params[:plate_size]
    @samples =  params[:samples]
    @reagents =  params[:reagents]
    @replicates = params[:replicates]
  end

  def call
    create_plate
    generate_experiment_results
    # binding.irb
    insert_data_into_plate
  end

  private

  def create_plate
    plate_template = get_plate
    @plate = Array.new(plate_template[0]) { Array.new(plate_template[1], {reagent: nil, sample: nil}) }
  end

  def get_plate
    template = {
      '96': [8, 12],
      '384': [16, 24]
    }
    template[@plate_size.to_s.to_sym]
  end

  def generate_experiment_results
    @result = []
    (0...@reagents.length).each do |i|
      array = []
      @reagents[i].each do |reagent|
        array2 = []
        @samples[i].each do |sample|
          mixture = {sample: sample.to_s, reagent: reagent.to_s}
          replicates = []
          @replicates[i].times do
            replicates << mixture
          end
          array2 << replicates
        end
        array << array2
      end
      @result << array
    end
  end

  def insert_data_into_plate
    #x offset
    current_pivot_x = 0
    offset = 0
    (0...@result.length).each do |experiment|
      (0...@result[experiment].length).each do |reagent|
        (0...@result[experiment][reagent].length).each do |mixture|
          skip = 0
          (0...@result[experiment][reagent][mixture].length).each do |replicate|
            if replicate+current_pivot_x >= get_plate[1]
              # binding.irb
              offset = replicate if offset == 0
              current_pivot_x -= offset
              skip += 1
            end
            @plate[mixture+skip][replicate+current_pivot_x] = @result[experiment][reagent][mixture][replicate]
          end
        end
        current_pivot_x += @replicates[experiment]
      end
    end
  end
end
