class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home, :imprint, :about]

  def home
  end

  def imprint
  end

  def about
  end
end
