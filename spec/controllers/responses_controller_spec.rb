require 'spec_helper'

describe ResponsesController do
  describe "POST receive_message" do
    context "yn poll with y followup and next question" do
      before :each do
        @p = FactoryGirl.create(:poll, :phone=>'14153334444')
        @q = @p.questions.create(:text=>"Would you ride along the blvd?", :question_type=>"YN")
        @y = @q.options.create(:text=>"yes", :value=>"y")
        @fup = Question.create(:text=>"Wyx?", :question_type=>"OPEN")
        @y.follow_up = @fup
        @y.save
        @q.options.create(:text=>"no", :value=>"n")
        @qn = @p.questions.create(:text=>"where are you from?", :question_type=>"OPEN")
      end

      describe "valid sms y answer with no previous responses" do
        it "should save a response and send the followup" do
          post :receive_message, TROPO_SMS_RESPONSE_Y
          @q.responses.length.should eq 1
          pending 'check that followup was sent'
        end
      end
      
      describe "valid sms n answer with no previous responses" do
        it "should save a response and send the next question" do
          post :receive_message, TROPO_SMS_RESPONSE_N
          @q.responses.length.should eq 1
          pending "check that next question was sent"
        end
      end

      describe "valid sms answer with previous y response" do
        it "should save a responses for the followup and send the next question" do
          post :receive_message, TROPO_SMS_RESPONSE_Y
          post :receive_message, TROPO_SMS_RESPONSE_OPEN
          @fup.responses.length.should eq 1
          pending "check that next question was sent"
        end
      end

      describe "valid sms answer with previous n (non-follow-up-triggering) response" do
        it "should save a response to the next question and say thanks" do
          post :receive_message, TROPO_SMS_RESPONSE_N
          post :receive_message, TROPO_SMS_RESPONSE_OPEN
          @qn.responses.length.should eq 1
          pending "check that we said thanks"
        end
      end

      describe "valid sms answer with two previous responses (y and anything)" do
        it "should create a new response to the next question and say thanks" do
          post :receive_message, TROPO_SMS_RESPONSE_Y
          post :receive_message, TROPO_SMS_RESPONSE_OPEN
          post :receive_message, TROPO_SMS_RESPONSE_OPEN
          @q.responses.length.should eq 1
          @fup.responses.length.should eq 1
          @qn.responses.length.should eq 1
          pending "check that we said thanks"
        end
      end 
    end

    context "yn poll" do
      before :each do
        @poll = FactoryGirl.create(:poll_yn, :phone=>'14153334444')
      end
      describe "sms with valid y response" do
        it "should create a new response" do
          post :receive_message, TROPO_SMS_RESPONSE_y
          @poll.responses.length.should eq 1
        end
      end
      describe "sms with valid YES response" do
        it "should create a new response" do
          post :receive_message, TROPO_SMS_RESPONSE_YES
          @poll.responses.length.should eq 1
        end
      end
      describe "sms with valid Y response" do
        it "should create a new response" do
          post :receive_message, TROPO_SMS_RESPONSE_Y
          @poll.responses.length.should eq 1
        end
      end

      describe "sms with valid n response" do
        it "should create a new response" do
          post :receive_message, TROPO_SMS_RESPONSE_n
          @poll.responses.length.should eq 1
        end
      end
      describe "sms with invalid response" do
        it "should create a new response" do
          post :receive_message, TROPO_SMS_RESPONSE_OPEN
          pending "behavior to be determined"
        end
      end
    end

    context "multiple choice poll" do
      before :each do
        @poll = FactoryGirl.create(:poll_multi, :phone=>'14153334444')
      end  
      
      describe "sms with valid parameters" do
        it "should create a new response" do
          post :receive_message, TROPO_SMS_RESPONSE_MULTI
          @poll.responses.length.should eq 1
        end
      end
    
      describe "sms with invalid parameters" do
        it "should not create a new response" do
          post :receive_message, TROPO_SMS_RESPONSE_OPEN
        end
      end
    end
    
    context "open-ended poll" do
      before :each do
        @poll = FactoryGirl.create(:poll_open, :phone=>'14153334444')
      end
      
      describe "sms with valid parameters" do
        it "should create a new response" do
          post :receive_message, TROPO_SMS_RESPONSE_OPEN
        end
      end
    
      describe "sms with invalid parameters" do
        it "should not create a new response" do
          post :receive_message, TROPO_SMS_RESPONSE_OPEN
        end
      end
      
    end
  end    
end
