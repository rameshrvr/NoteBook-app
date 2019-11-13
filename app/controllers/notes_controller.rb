class NotesController < ApplicationController
  before_action :set_note, only: [:show, :edit, :update, :destroy]
  before_action :validate_user_login

  # GET /notes
  # GET /notes.json
  def index
    @notes = Note.where(created_by: session[:user_id]).all
  end

  # GET /notes/1
  # GET /notes/1.json
  def show
  end

  # GET /notes/new
  def new
    @note = Note.new
  end

  # GET /notes/1/edit
  def edit
  end

  # POST /notes
  # POST /notes.json
  def create
    @note = Note.new(note_params)
    @note.created_by = session[:user_id]

    respond_to do |format|
      if @note.save
        format.html { redirect_to @note, notice: 'Note successfully created.' }
        format.json { render :show, status: :created, location: @note }
      else
        format.html { render :new }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /notes/1
  # PATCH/PUT /notes/1.json
  def update
    respond_to do |format|
      if @note.update(note_params)
        format.html { redirect_to @note, notice: 'Note successfully updated.' }
        format.json { render :show, status: :ok, location: @note }
      else
        format.html { render :edit }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /notes/1
  # DELETE /notes/1.json
  def destroy
    @note.destroy
    respond_to do |format|
      format.html { redirect_to notes_url, notice: 'Note successfully deleted.' }
      format.json { head :no_content }
    end
  end

  # GET /notes/1/send_mail
  def send_mail
    @note_details = Note.find(params[:id])
    @user_details = UserProfile.find(session[:user_id])
    NotesMailer.with(notes: @note_details, user: @user_details).send_notes_to_user.deliver_later

    respond_to do |format|
      format.html { redirect_to notes_url, notice: 'Email successfully sent.' }
    end
  end

  # GET /notes/update_visibility
  def update_visibility
    note_obj = Note.find(params[:id])
    converted_value = ActiveModel::Type::Boolean.new.cast(params[:public_view])
    note_obj.update_attribute :public_view, !converted_value
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_note
      @note = Note.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def note_params
      params.require(:note).permit(:title, :description)
    end

    # Check for valid session id
    def logged_in?
      !session[:user_id].nil?
    end

    def validate_user_login
      unless logged_in?
        flash[:danger] = "Please log in."
        redirect_to root_url
      end
    end
end
