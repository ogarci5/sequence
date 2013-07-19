set (:auth) do |type|
  condition do
  	if type == :admin
  		redirect "/sequence" unless send("is_admin?")
  	end
    redirect "/login" unless send("is_#{type}?")
  end
end

helpers do
  def is_user?
    @authorized_user != nil
  end
  def is_admin?
    @admin != nil
  end
end

before do
  @authorized_user = User.get(request.cookies['user_id'])
  @authorized_user.nil? ? @admin = nil : @authorized_user.name == "Oliver" ? @admin = @authorized_user : @admin = nil
  $messages ||= {}
end
