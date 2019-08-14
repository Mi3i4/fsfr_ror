require 'json'
class QuestionController < ApplicationController

    def give_database
        @database_hash = XlsxToJson.get_database("public/fsfr_questions_and_answers.xlsx")
        # pp database_hash
        render :show, status: :ok
    end
end
