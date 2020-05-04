require 'test_helper'

class InstructionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @instruction = instructions(:one)
  end

  test "should get index" do
    get instructions_url, as: :json
    assert_response :success
  end

  test "should create instruction" do
    assert_difference('Instruction.count') do
      post instructions_url, params: { instruction: {  } }, as: :json
    end

    assert_response 201
  end

  test "should show instruction" do
    get instruction_url(@instruction), as: :json
    assert_response :success
  end

  test "should update instruction" do
    patch instruction_url(@instruction), params: { instruction: {  } }, as: :json
    assert_response 200
  end

  test "should destroy instruction" do
    assert_difference('Instruction.count', -1) do
      delete instruction_url(@instruction), as: :json
    end

    assert_response 204
  end
end
