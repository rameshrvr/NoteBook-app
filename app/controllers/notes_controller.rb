class NotesController < ApplicationController
  before_action :set_note, only: [:show, :edit, :update, :destroy, :popup]
  before_action :validate_user_login
  before_action :validate_user, only: [:show, :edit, :update, :destroy]
  before_action :prevent_modify, only: [:edit, :update, :destroy]

  # GET /notes
  # GET /notes.json
  def index
    # Get shared notes for the user
    @shared_note_ids = ShareNote.where('user_profile_id = ?', session[:user_id]).pluck(:note_id)
    @notes = Note.where(
      'created_by = ? or public_view = ? or id in (?)',
      session[:user_id], true, @shared_note_ids
    )
    ###
    # Get usernames for public note
    @user_names = {}
    @notes.each do |note|
      unless note.created_by.to_s.eql? session[:user_id].to_s
        user_details = UserProfile.find(note.created_by)
        @user_names[user_details.id.to_s] = user_details.name
      end
    end
  end

  # GET /notes/1
  # GET /notes/1.json
  def show
    if @note.public_view or @shared_user_ids.include?(session[:user_id]) or (!@note.public_view and @shared_user_ids.any?)
      @comments = Comment.where('note_id = ?', params[:id])
      others_comment_ids = []
      # Get the user ids from all comments for a note
      @comments.each do |single_comment|
        unless single_comment.created_by.to_s.eql? session[:user_id].to_s
          others_comment_ids.push(single_comment.created_by)
        end
      end
      ###
      @user_names = {}
      ###
      user_details = UserProfile.where('id in (?)', others_comment_ids)
      user_details.each do |detail|
        @user_names[detail.id.to_s] = detail.name
      end
    end
  end

  # GET /notes/new
  def new
    @note = Note.new
  end

  # GET /notes/1/edit
  def edit
  end

  # Get /notes/popup
  def popup
    @shared_users = ShareNote.where('note_id = ?', params[:id]).pluck(:user_profile_id)
    @all_users = UserProfile.where('not id = ?', session[:user_id])
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

  # GET /notes/create_comment
  def create_comment
    comment = Comment.new
    comment.note_id = params[:id]
    comment.created_by = session[:user_id]
    comment.description = params[:comment]
    comment.save
  end

  # GET /notes/1/share_notes
  def share_notes
    shared_userids = ShareNote.where('note_id = ?', params[:id]).pluck(:user_profile_id)
    # Create a mapping in DB with user_id and note_id for each share
    if !params[:user_ids].nil?
      params[:user_ids].each do |user_id|
        unless shared_userids.include?(user_id.to_i)
          @share = ShareNote.new
          @share.user_profile_id = user_id
          @share.note_id = params[:note_id]
          @share.save
        else
          shared_userids.delete(user_id.to_i)
        end
      end
    end
    # Delete records to unshare note
    unless shared_userids.empty?
      shared_userids.each do |delete_user_id|
        ShareNote.where('note_id = ? and user_profile_id = ?', params[:note_id], delete_user_id).destroy_all
      end
    end

    respond_to do |format|
      format.json { render json: { location: notes_url } }
    end
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

  def validate_user
    note_details = Note.find(params[:id])
    @shared_user_ids = ShareNote.where('note_id = ?', note_details.id).pluck(:user_profile_id)
    if note_details.public_view.eql? false and !@shared_user_ids.include?(session[:user_id])
      unless note_details.created_by.to_s.eql?(session[:user_id].to_s)
        render(
          html: "<script>alert('Access Denied!')</script>".html_safe,
          layout: 'application'
        )
      end
    end
  end

  def prevent_modify
    note_details = Note.find(params[:id])
    unless note_details.created_by.to_s.eql?(session[:user_id].to_s)
      render(
        html: "<script>alert('Access Denied!')</script>".html_safe,
        layout: 'application'
      )
    end
  end
end
