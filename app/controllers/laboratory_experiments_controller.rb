class LaboratoryExperimentsController < ApplicationController
  def new

  end

  def create
    service = PlateContentGeneratorService.new(create_params)
    service.call
  end

  private

  def create_params
    #test_params
    # {
    #   plate_size: 96,
    #   samples: [['Sample-1', 'Sample-2', 'Sample-3'], ['Sample-1' ,'Sample-2', 'Sample-3']],
    #   reagents: [['<Pink>'],['<Green>']],
    #   replicates: [3, 2]
    # }

    params.permit(:plate_size, samples: [], reagents: [], replicates: [])
  end
end
