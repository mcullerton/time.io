class TimeEntriesController < ApplicationController

  before_filter :authenticate_user!

  # GET /time_entries
  # GET /time_entries.json
  def index
    @invoiced_entries = @time_entries.invoiced?.order("date DESC")
    @open_entries = @time_entries.invoiced!.order("date DESC")
    @time_entry = TimeEntry.new
    @new_invoice = Invoice.new

    respond_to do |format|
      if current_user.nil?
        format.html { redirect_to "/signin" }
      else
      format.html # index.html.erb
      format.json { render json: @time_entries }
      end
    end
  end

  # GET /time_entries/1
  # GET /time_entries/1.json
  def show
    @time_entry = TimeEntry.find(params[:id])

    respond_to do |format|
      if current_user.nil?
        format.html { redirect_to "/signin" }
      else
        format.html # show.html.erb
        format.json { render json: @time_entry }
      end
    end
  end

  # GET /time_entries/new
  # GET /time_entries/new.json
  def new
    @time_entry = TimeEntry.new

    respond_to do |format|
      if current_user.nil?
        format.html  redirect_to "/signin"
      else
        format.html # new.html.erb
        format.json { render json: @time_entry }
      end

    end
  end

  # GET /time_entries/1/edit
  def edit
    @time_entry = TimeEntry.find(params[:id])
  end

  # POST /time_entries
  # POST /time_entries.json
  def create
    params[:time_entry][:date] = Date.strptime(params[:time_entry][:date],"%m/%d/%Y")
    params[:time_entry][:user_id] = current_user.id
    @time_entry = TimeEntry.new(params[:time_entry])

    respond_to do |format|
      if current_user.nil?
        format.html  redirect_to "/signin"
      else
      if @time_entry.save
        format.html { redirect_to :back, notice: 'Time entry was successfully created.' }
        format.json { render json: @time_entry, status: :created, location: @time_entry }
      else
        format.html { render action: "new" }
        format.json { render json: @time_entry.errors, status: :unprocessable_entity }
      end
      end

    end
  end

  # PUT /time_entries/1
  # PUT /time_entries/1.json
  def update
    #date = params[:time_entry][:date]
    #params[:time_entry][:date] = Date.strptime(date,"%m/%d/%Y")
    @time_entry = TimeEntry.find(params[:id])

    respond_to do |format|
      if current_user.nil?
        format.html  redirect_to "/signin"
      else
      if @time_entry.update_attributes(params[:time_entry])
        format.html { redirect_to @time_entry, notice: 'Time entry was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @time_entry.errors, status: :unprocessable_entity }
      end
      end

    end
  end

  # DELETE /time_entries/1
  # DELETE /time_entries/1.json
  def destroy
    @time_entry = TimeEntry.find(params[:id])
    @time_entry.destroy

    respond_to do |format|
      if current_user.nil?
        format.html  redirect_to "/signin"
      else
      format.html { redirect_to time_entries_url }
      format.json { head :no_content }
      end
    end
  end
end
