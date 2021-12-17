class Public::CalendarsController < ApplicationController
  def index
    @calendars = Calendar.all
    @items = Item.all
  end

end