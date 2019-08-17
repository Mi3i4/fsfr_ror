require "json"

class QuestionController < ApplicationController
  def give_database
    @database_hash = XlsxToJson.get_database("public/fsfr_questions_and_answers.xlsx")
    # pp database_hash
    render :show, status: :ok
  end

  def give_chapters
    database_hash = XlsxToJson.get_database("public/fsfr_questions_and_answers.xlsx")
    chapters_row = database_hash.map { |ch| 
        chapter = ch[:chapter]
    }
    @chapters = chapters_row.to_set.to_a
    render :show_chapters, status: :ok
  end
end
