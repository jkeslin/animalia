post '/users/login' do
  @user = User.find_by_email(params[:email])
  if @user.authenticate(params[:password])
    session[:user_id] = @user.id
  end
  redirect '/'
end

get '/users/new' do
  erb :"users/new"
end

get '/logout' do
  session.clear
  redirect '/'
end

# register

get 'users/new' do
  erb :'users/new'
end

# profile (show user collections)

get '/users/profile/:id' do 
  current_user
  @collections = @user.collections
  unless @collections.empty?
    @cards = Card.where(user_id: current_user.id)
  end
  erb :'users/profile'
end

# Edit Collection

get '/collection/edit/:id' do
  @user = User.find(session[:user_id])
  @collection = Collection.find(params[:id])
  @cards = Card.where(collection_id: @collection.id)
  erb :'collection/edit'
end

# POST __________

# Login

post '/login' do
  @user = User.find_by(params[:email])
  if @user
    if @user.authenticate(params[:password])
      session[:user_id] = @user.id
    end
    redirect '/'
  else
    @error = "Uh oh, login unsuccessful"
    erb :index
  end
end

# Register

post '/signup' do
  @user = User.new(params[:user])
  if @user.save
    session[:user_id] = @user.id
    redirect '/'
  else
    erb :'users/new'
  end
end

#create collection

post '/collection/new' do
  @collection = Collection.create(name: params["name"])
  @bobolink = Species.find_by(scientific_name: "Dolichonyx oryzivorus")
  @card = Card.create(user_id: current_user.id, collection_id: @collection.id, species_id: @bobolink.id)
  redirect "/users/profile/#{current_user.id}"
end

# Edit Collection

post '/collection/edit/:id' do
  @user = User.find(session[:user_id])
  @collection = Collection.find(params[:id])
  @collection.update(name: params[:name])

  redirect "/users/profile/#{@user.id}"
end


# Delete Collection

post '/collection/delete/:id' do
  @user = User.find(session[:user_id])
  @collection = Collection.find(params[:id])
  @collection.destroy

  redirect "/users/profile/#{@user.id}"
end

#delete card from collection
post '/card/delete' do
  @user = User.find(session[:user_id])
  @cards = Card.find_by(params[:collection_id])

  @card.destroy

end

