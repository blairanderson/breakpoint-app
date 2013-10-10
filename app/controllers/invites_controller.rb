class InvitesController < ApplicationController
  layout 'team'
  before_action :load_team

  def index
    @invites = @team.invites.includes(:user).order('accepted_at asc')
    if params[:search].present?
      @users = params[:search].split(/\s+/).map do |name|
        User.where('lower(email) LIKE lower(:search) or lower(first_name) LIKE lower(:search) or lower(last_name) LIKE lower(:search)', :search => "%#{name}%").to_a
      end.flatten.uniq
      if @users.blank? && params[:search].match(Devise.email_regexp).present?
        @email = params[:search]
      end
    end
  end

  def create
    @invite = @team.invites.build(permitted_params.invite)

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
        new_user.save!
        @invite.user = new_user
        is_new_user = true
      end

      @invite.invited_by = current_user
      @invite.save!
      @team.users << @invite.user
      @team.save!
    end

    if is_new_user
      InviteMailer.delay.new_user_invitation(@team.id, @invite.id)
    else
      InviteMailer.delay.invitation(@team.id, @invite.id)
    end

    redirect_to team_invites_url(@team), :notice => 'Invite sent'
  rescue
    flash[:error] = 'Error occurred. Was that user already invited?'
    redirect_to team_invites_url(@team)
  end

  def update
    @invite = Invite.find(params[:id])
    authorize @invite

    if @invite.accepted?
      return redirect_to team_team_members_url(@team), :notice => 'Invite accepted'
    end

    Invite.transaction do
      @invite.accepted_at = Time.now
      @invite.save!
    end
    redirect_to team_team_members_url(@team), :notice => 'Invite accepted'
  end

  private

  def load_team
    @team = current_user.teams.find(params[:team_id])
  end
end

