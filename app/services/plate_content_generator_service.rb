class PlateContentGeneratorService < ApplicationService
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

  def plate
    result = ""
    @plate.each do |row|
      result += (row.to_s + "\n")
    end
    result
  end

  private

  def create_plate
    plate_template = get_plate
    @plate = Array.new(plate_template[0]) { Array.new(plate_template[1]) }
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
          mixture = [sample.to_s, reagent.to_s]
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
    prev_exp = 0
    (0...@result.length).each do |experiment|
      (0...@result[experiment].length).each do |reagent|
        (0...@result[experiment][reagent].length).each do |mixture|
          (0...@result[experiment][reagent][mixture].length).each do |replicate|
            @plate[mixture][replicate+prev_exp] = @result[experiment][reagent][mixture][replicate]
            # binding.irb
          end
        end
        prev_exp += @replicates[reagent]
      end
      #correct x offset
      prev_exp += @replicates[experiment] - 2
    end
  end
end
