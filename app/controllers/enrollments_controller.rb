class EnrollmentsController < ApplicationController
  before_action :set_enrollment, only: %i[ show edit update destroy certificate ]
  before_action :set_course, only: %i[ new create ]

  # GET /enrollments or /enrollments.json
  def index
    @enrollments = Enrollment.all
    authorize @enrollments
  end

  def certificate
    authorize @enrollment, :certificate?
    respond_to do |format|
      format.html
      format.pdf do
          render pdf: "#{@enrollment.course.title}, #{@enrollment.user.email}",         
          template: 'enrollments/certificate.pdf.haml'          
      end 
    end 
  end
  
  def my_students
    @enrollments=Enrollment.joins(:course).where(course: {user: current_user})    
    render "index"
  end
  

  # GET /enrollments/1 or /enrollments/1.json
  def show
  end

  # GET /enrollments/new
  def new
    @enrollment = Enrollment.new
  end

  # GET /enrollments/1/edit
  def edit
    authorize @enrollment
  end

  # POST /enrollments or /enrollments.json
  def create
    if @course.price > 0
      @amount = (@course.price*100).to_i
      customer = Stripe::Customer.create({
        email: params[:stripeEmail],
        source: params[:stripeToken],
      })

      charge = Stripe::Charge.create({
        customer: customer.id,
        amount: @amount,
        description: 'Skill up premium content',
        currency: 'usd',
      })
      
    end

    EnrollmentMailer.student_enrollment(@enrollment).deliver_later
    EnrollmentMailer.teacher_enrollment(@enrollment).deliver_later

    @enrollment = current_user.buy_course(@course)
    redirect_to course_path(@course), notice: "You are enrolled successfully!"

    rescue Stripe::CardError => e
      flash[:alert] = e.message
      redirect_to course_path(@course)      

  end

  # PATCH/PUT /enrollments/1 or /enrollments/1.json
  def update
    authorize @enrollment
    respond_to do |format|
      if @enrollment.update(enrollment_params)
        format.html { redirect_to course_path(@enrollment.course), notice: "Rated successfully!" }
        format.json { render :show, status: :ok, location: @enrollment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @enrollment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /enrollments/1 or /enrollments/1.json
  def destroy
    # authorize @enrollment
    @enrollment.destroy
    respond_to do |format|
      format.html { redirect_to enrollments_url, notice: "Enrollment was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_enrollment
      @enrollment = Enrollment.friendly.find(params[:id])
    end

    def set_course
      @course = Course.friendly.find(params[:course_id])
    end

    # Only allow a list of trusted parameters through.
    def enrollment_params
      params.require(:enrollment).permit(:rating, :review)
    end
end
