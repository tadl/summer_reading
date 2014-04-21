require 'test_helper'

class ParticipantsControllerTest < ActionController::TestCase
  setup do
    @participant = participants(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:participants)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create participant" do
    assert_difference('Participant.count') do
      post :create, participant: { age: @participant.age, club: @participant.club, email: @participant.email, first_name: @participant.first_name, grade: @participant.grade, home_library: @participant.home_library, last_name: @participant.last_name, library_card: @participant.library_card, middle_name: @participant.middle_name, school: @participant.school, zip_code: @participant.zip_code }
    end

    assert_redirected_to participant_path(assigns(:participant))
  end

  test "should show participant" do
    get :show, id: @participant
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @participant
    assert_response :success
  end

  test "should update participant" do
    patch :update, id: @participant, participant: { age: @participant.age, club: @participant.club, email: @participant.email, first_name: @participant.first_name, grade: @participant.grade, home_library: @participant.home_library, last_name: @participant.last_name, library_card: @participant.library_card, middle_name: @participant.middle_name, school: @participant.school, zip_code: @participant.zip_code }
    assert_redirected_to participant_path(assigns(:participant))
  end

  test "should destroy participant" do
    assert_difference('Participant.count', -1) do
      delete :destroy, id: @participant
    end

    assert_redirected_to participants_path
  end
end
