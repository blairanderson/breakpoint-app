class InvitesController < ApplicationController
  layout 'season'
  before_filter :load_season

  def index
    @invites = @season.invites.includes(:user).order('accepted_at asc')
    if params[:search].present?
      @users = User.where('email LIKE :search or first_name LIKE :search or last_name LIKE :search', :search => "%#{params[:search]}%")
      if @users.blank? && params[:search].match(Devise.email_regexp).present?
        @email = params[:search]
      end
    end
  end

  def create
    @invite = @season.invites.build(params[:invite])

    Invite.transaction do
      user = User.where(:email => params[:email]).first
      if user.present?
        @invite.user = user
      else
        new_user = User.new(:email => params[:email])
        new_user.password = SecureRandom.uuid
        new_user.reset_password_token = User.reset_password_token
        new_user.reset_password_sent_at = Time.now
        new_user.save!
        @invite.user = new_user
      end

      @invite.invited_by = current_user
      @invite.save!
    end
    # TODO send invitation email
    redirect_to season_invites_url(@season), :notice => 'Invite sent'
  end

  def update
    @invite = Invite.find(params[:id])
    # TODO authorize invite
    Invite.transaction do
      @invite.accepted_at = Time.now
      @invite.save!
      @season.users << current_user
      @season.save!
    end
    redirect_to season_team_members_url(@season), :notice => 'Invite accepted'
  end

  def destroy
    @invite = Invite.find(params[:id])
    @invite.destroy

    redirect_to season_invites_url(@season), :notice => 'Invite deleted'
  end

  private

  def load_season
    @season = Season.find(params[:season_id])
  end
end

