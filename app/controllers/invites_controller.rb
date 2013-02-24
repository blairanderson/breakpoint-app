class InvitesController < ApplicationController
  layout 'team'
  before_filter :load_team

  def index
    @invites = @team.invites.includes(:user).order('accepted_at asc')
    if params[:search].present?
      @users = User.where('email LIKE :search or first_name LIKE :search or last_name LIKE :search', :search => "%#{params[:search]}%")
      if @users.blank? && params[:search].match(Devise.email_regexp).present?
        @email = params[:search]
      end
    end
  end

  def create
    @invite = @team.invites.build(params[:invite])

    is_new_user = false
    Invite.transaction do
      user = User.where(:email => @invite.email).first
      if user.present?
        @invite.user = user
      else
        new_user = User.new
        new_user.first_name             = @invite.first_name
        new_user.last_name              = @invite.last_name
        new_user.email                  = @invite.email
        new_user.password               = SecureRandom.uuid
        new_user.reset_password_token   = User.reset_password_token
        new_user.reset_password_sent_at = Time.now
        new_user.save!
        @invite.user = new_user
        is_new_user = true
      end

      @invite.invited_by = current_user
      @invite.save!
    end

    if is_new_user
      InviteMailer.new_user_invitation(@invite).deliver
    else
      InviteMailer.invitation(@invite).deliver
    end

    redirect_to team_invites_url(@team), :notice => 'Invite sent'
  end

  def update
    @invite = Invite.find(params[:id])
    # TODO authorize invite
    Invite.transaction do
      @invite.accepted_at = Time.now
      @invite.save!
      @team.users << current_user
      @team.save!
    end
    redirect_to team_team_members_url(@team), :notice => 'Invite accepted'
  end

  def destroy
    @invite = Invite.find(params[:id])
    @invite.destroy

    redirect_to team_invites_url(@team), :notice => 'Invite deleted'
  end

  private

  def load_team
    @team = Team.find(params[:team_id])
  end
end

