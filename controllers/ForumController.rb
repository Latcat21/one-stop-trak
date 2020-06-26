class ForumController < ApplicationController

  get ('/') do
   @posts = Post.all
    erb :all_post
  end

  get ('/new') do
    # making it so only logged in users can like posts
    if !session[:logged_in]
       session[:message] = {
        success: false,
        status: "bad",
        message: "You must be logged in to do that"
          }
      
    redirect '/users/login'
    end
    erb :new_post
  end

  post ('/new') do
    #making sure forms are filled in
    if params[:title] == '' || params[:content] == ''
        session[:message] = {
          success: false,
          status: "bad",
          message: "please fill in the fields"
        }
        redirect '/posts/new'
    end
    
    logged_in_user = User.find_by ({ :username => session[:username] })

    new_post = Post.create(title: params[:title], content: params[:content], author: logged_in_user.username, img: logged_in_user.img, user_id: logged_in_user.id )

    redirect '/posts'
  end

    #page for logged in users posts
  get ('/your-posts') do
      user = User.find_by ({ :username => session[:username] })
      @posts = user.posts
      erb :user_posts
  end

    #get route for individual post
    get  '/:id' do
     @post = Post.find params[:id]
      @likes = @post.likes.count
      erb :post_show
    end

    #get route for post edit route
    get '/:id/edit' do
      @post = Post.find params[:id]
      erb :edit_post
    end 
      
    #edit route for editing a post
    put '/:id' do
      post = Post.find params[:id]
      post.title = params[:title]
      post.content = params[:content]
      post.save
      redirect '/posts'
    end

    #delete route for deleting a post
    delete '/:id' do
        post = Post.find params[:id]
        post.destroy
        session[:message] = {
          success: true,
          status: "good",
          message: "Successfully destroyed post ##{post.id}"
        }
        redirect "/days"
     end

   #posting a comment to a post
    post '/:id/comments' do
        #only logged in users can comment on posts
        if !session[:logged_in]
            session[:message] = {
            success: false,
            status: "bad",
            message: "You must be logged in to do that"
          }
          #redirect
          redirect '/users/login'
        end
   

        if params[:comment] == ''
          session[:message] = {
          success: false,
          status: "bad",
          message: "please fill in the feilds"
          }
          redirect '/posts'
        end
           
        found_post = Post.find params[:id]
        logged_in_user = User.find_by ({ :username => session[:username] })

        #creating a new comment
        new_comment = Comment.create(comment: params[:comment], post_id: found_post.id, author: logged_in_user.username, user_id: logged_in_user.id )
        
        redirect '/posts'

    end

    post '/:id/likes' do


      # making it so only logged in users can like posts
      if !session[:logged_in]
        #message
        session[:message] = {
          success: false,
          status: "bad",
          message: "You must be logged in to do that"
        }
        #redirect
        redirect '/users/login'
      end
       
      logged_in_user = User.find_by ({ :username => session[:username] })
      #grabbing the post by Id
      found_post = Post.find params[:id]
      
      #check to see if ther user liked it already

      found_post.likes.each do | like |
        if like.user_id == logged_in_user.id
          session[:message] = {
              success: false,
              status: "bad",
              message: "You already liked this post"
            }
            redirect '/posts'
          end
      end
    #creating a new like
      new_like = Like.new
      #assignged the post id to the like id
      new_like.post_id = found_post.id
    
      #storing the user id to the comment
      new_like.user_id = logged_in_user.id
      #saving the like
      new_like.save
      # redirecting to the all posts
      redirect '/posts'

    end


end