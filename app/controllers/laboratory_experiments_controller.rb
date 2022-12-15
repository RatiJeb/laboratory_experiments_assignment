class LaboratoryExperimentsController < ApplicationController
  def new

  end

  def create
    service = PlateContentGeneratorService.new(create_params)
    service.call
    @plate = service.plate
    render "show"
  end

  private

  def create_params
    # test_params
    {
      plate_size: 96,
      samples: [['Sample-1', 'Sample-2', 'Sample-3'], ['Sample-1' ,'Sample-2', 'Sample-3'], ['Sample-4']],
      reagents: [['Pink', 'Yellow'],['Green', 'Blue'],['Violet']],
      replicates: [1, 3, 2]
    }
    #
    # params.permit(:plate_size, samples: [], reagents: [], replicates: [])
  end
end
