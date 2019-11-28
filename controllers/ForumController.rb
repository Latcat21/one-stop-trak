class ForumController < ApplicationController

  get ('/') do
    #displaying all the posts
    @posts = Post.all
    erb :all_post
  end

  

  get ('/new') do
    # making it so only logged in users can like posts
    if !session[:logged_in]
    #message
    session[:message] = {
      success: false,
      status: "neutral",
      message: "You must be logged in to do that"
          }
      #redirect
    redirect '/users/login'
    end
    erb :new_post
  end

  post ('/new') do
    new_post = Post.new
    new_post.title = params[:title]
    new_post.content = params[:content]
    if new_post.title == '' || new_post.content == ''
    session[:message] = {
      success: false,
      status: "bad",
      message: "please fill in the feilds"
      }
    redirect '/posts/new'
    end

    if new_post.content.length <= 20 
      session[:message] = {
      success: false,
      status: "bad",
      message: "please submit a longer poster"
      }
    redirect '/posts/new'
    end
    logged_in_user = User.find_by ({ :username => session[:username] })
    new_post.author = logged_in_user.username
    new_post.user_id = logged_in_user.id
    new_post.img = logged_in_user.img
    new_post.save
    
    redirect '/posts'
  end

    
    get ('/your-posts') do
      #grabbing the user that is logged in
      user = User.find_by ({ :username => session[:username] })
      #displaying all the posts by the logged in user
      @posts = user.posts

      erb :user_posts
    end

      get  '/:id' do
      # grabbing all the posts
      @post = Post.find params[:id]
      #find how many likes are on that post
      @likes = @post.likes.count
      erb :post_show

      end

      get '/:id/edit' do
      #finding the post
      @post = Post.find params[:id]

      erb :edit_post

      end
      
      put '/:id' do
        #finding the post
        post = Post.find params[:id]
        #updated it
        post.title = params[:title]
        post.content = params[:content]
        #save it
        post.save
        #redirect
        redirect '/posts'
        
      end

 


      delete '/:id' do
        post = Post.find params[:id]
        # access the comments
        comments = post.comments
        #looping through the array to destroy the relationship
        comments.each do |relation|
          relation.destroy
        end

        #accessing the likes
        likes = post.likes
        #looping through the array to destroy the relationship
        likes.each do |relation|
          relation.destroy
        end
        #deleting the post
        post.destroy
        #updating the sessiongs
        session[:message] = {
          success: true,
          status: "good",
          message: "Successfully destroyed post ##{post.id}"
        }
        redirect "/days"
        

      end

      post '/:id/comments' do
        #only logged in users can comment on posts
        if !session[:logged_in]
          #message
          session[:message] = {
            success: false,
            status: "neutral",
            message: "You must be logged in to do that"
          }
          #redirect
          redirect '/users/login'
        end
    
        #grabbing the post by Id
        found_post = Post.find params[:id]
        #creating a new comment
        new_comment = Comment.new 
        #storing the inputs
        new_comment.comment = params[:comment]
        if new_comment.comment == ''
        session[:message] = {
        success: false,
        status: "bad",
        message: "please fill in the feilds"
        }
        redirect '/posts'
        end
    
        #storing the post id's in the comment
        new_comment.post_id= found_post.id
        #finding the logged in user
        logged_in_user = User.find_by ({ :username => session[:username] })
        #storing the logged in users name to the comment
        new_comment.author = logged_in_user.username
        #storing the user id to the comment
        new_comment.user_id = logged_in_user.id
        #saving the new comment
        new_comment.save
        #redirecting to all the posts
        redirect '/posts'

    end

    post '/:id/likes' do
      # making it so only logged in users can like posts
      if !session[:logged_in]
        #message
        session[:message] = {
          success: false,
          status: "neutral",
          message: "You must be logged in to do that"
        }
        #redirect
        redirect '/users/login'
      end
      #grabbing the post by Id
      found_post = Post.find params[:id]
      #creating a new like
      new_like = Like.new
      #assignged the post id to the like id
      new_like.post_id = found_post.id
      #finding the logged in user
      logged_in_user = User.find_by ({ :username => session[:username] })
      #storing the user id to the comment
      new_like.user_id = logged_in_user.id
      #saving the like
      new_like.save
      # redirecting to the all posts
      redirect '/posts'

    end


end