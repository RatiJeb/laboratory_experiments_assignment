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
    insert_data_into_plate
  end

  private

  def create_plate
    plate_template = get_plate
    @plate = Array.new(plate_template[0]) { Array.new(plate_template[1]) }
  end

  def get_plate
    template = {
      '96': [12, 8],
      '384': [16, 24]
    }
    template[@plate_size.to_s.to_sym]
  end

  def generate_experiment_results
    @result = []
    (0...@samples.length).each do |i|
      array = []
      @samples[i].each do |sample|
        mixture = sample.to_s + ' + ' + @reagents[i][0].to_s
        replicates = []
        @replicates[i].times do
          replicates << mixture
        end
        array << replicates
      end
      @result << array
    end
  end

  def insert_data_into_plate
    prev_exp = 0
    (0...@result.length).each do |experiment|
      (0...@result[experiment].length).each do |mixture|
        (0...@result[experiment][mixture].length).each do |replicate|
          @plate[mixture][replicate+prev_exp] = @result[experiment][mixture][replicate]
        end
      end
      prev_exp += @replicates[experiment]
    end
  end
end
