class PrototypesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_prototype, except: [:index, :new, :create]
  before_action :move_to_index, only: [:edit, :update, :destroy]
  
  
  def index

    @prototypes = Prototype.includes(:user)
  end

  def new
    @prototype = Prototype.new
  end

  def create
    @prototype = Prototype.new(prototype_params)
    if @prototype.save
      redirect_to root_path
    else
      @prototypes = Prototype.includes(:user)
      render :new
    end
  end
    def show
      @prototype = Prototype.find(params[:id])
      @comment = Comment.new
      @comments = @prototype.comments.includes(:user)
    end

    def edit
      @prototype = Prototype.find(params[:id])
    end

    def update
      @prototype = Prototype.find(params[:id])
      if @prototype.update(prototype_params)
        redirect_to prototype_path(@prototype)
      else
        render :edit
      end
    end

    def destroy
      @prototype = Prototype.find(params[:id])
      @prototype.destroy
      redirect_to root_path
    end
  

  private
  def prototype_params
    
    params.require(:prototype).permit(:title, :catch_copy, :concept, :image).merge(user_id: current_user.id)
  end

  def move_to_index
    
    redirect_to root_path unless current_user == @prototype.user
  end

  def set_prototype
    @prototype = Prototype.find(params[:id])
  end

 

end
