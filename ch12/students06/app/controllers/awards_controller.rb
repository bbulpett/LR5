class AwardsController < ApplicationController
  before_action :get_student
  before_action :set_award, only: [:show, :edit, :update, :destroy]

  # GET /awards
  # GET /awards.json
  def index
    # @awards = Award.all
    @awards = @student.awards
  end

  # GET /awards/1
  # GET /awards/1.json
  def show
    #raise @award.to_yaml
  end

  # GET /awards/new
  def new
    # @award = Award.new
    @award = @student.awards.build
  end

  # GET /awards/1/edit
  def edit
  end

  # POST /awards
  # POST /awards.json
  def create
    # @award = Award.new(award_params)
    @award = @student.awards.build(award_params)

    respond_to do |format|
      if @award.save
        # format.html { redirect_to @award, notice: 'Award was successfully created.' }
        format.html { redirect_to student_awards_url(@student), notice: 'Award was successfully created.' }
        format.json { render :show, status: :created, location: @award }
      else
        format.html { render :new }
        format.json { render json: @award.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /awards/1
  # PATCH/PUT /awards/1.json
  def update

    respond_to do |format|
      if @award.update(award_params)
        format.html { redirect_to student_awards_url(@student), notice: 'Award was successfully updated.' }
        # format.html { redirect_to @award, notice: 'Award was successfully updated.' }
        format.json { render :show, status: :ok, location: @award }
      else
        format.html { render :edit }
        format.json { render json: @award.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /awards/1
  # DELETE /awards/1.json
  def destroy
    @award.destroy
    respond_to do |format|
      format.html { redirect_to (student_awards_path(@student)), notice: 'Award was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # get_student converts the student_id given by the routing
    # into an @student object, for use here and in the view
    def get_student
      @student = Student.find(params[:student_id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_award
      @award = @student.awards.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def award_params
      params.require(:award).permit(:name, :year, :student_id)
    end
end
