class V1::PublishersController < ApplicationController
  def index
    publishers = Publisher.all
    render json: publishers.as_json
  end
end
