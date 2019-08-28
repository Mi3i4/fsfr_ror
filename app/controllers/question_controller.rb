require "json"

class QuestionController < ApplicationController
  before_action :authenticate_user!

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

  def ten_question
    # {
    #     "chapter": {
    #         "number": "1",
    #         "name": "Рынок ценных бумаг"
    #     },
    #     "theme": {
    #         "number": "1",
    #         "name": " Функционирование финансового рынка"
    #     },
    #     "question": {
    #         "number": "1",
    #         "subject": "Финансовый рынок представляет собой:",
    #         "cod": "1.1.1."
    #     },
    #     "answers": {
    #         "a": [
    #             "A.Механизм перераспределения капитала между кредиторами и заемщиками при помощи посредников на основании спроса и предложения на капитал",
    #             "0"
    #         ],
    #         "b": [
    #             "B.Совокупность кредитно-финансовых организаций страны, перераспределяющих потоки денежных средств между субъектами, имеющими временно свободные денежные средства и субъектами, испытывающими недостаток в финансовых ресурсах",
    #             "0"
    #         ],
    #         "c": [
    #             "C.Институт, трансформирующий сбережения в инвестиции",
    #             "0"
    #         ],
    #         "d": [
    #             "D.Все перечисленное",
    #             "1"
    #         ],
    #         "e": []
    #     }
    # },

    chapter_number = params[:chapter_num]
    question_database = XlsxToJson.get_database("public/fsfr_questions_and_answers.xlsx").filter { |q| q.dig(:chapter, :number) == chapter_number }
    current_user
    # @current_user.answered = ["1.1.1.", "2.1.2.", "3.3.1."]
    answered = @current_user.answered
    chapter_answered = answered.map { |k, v|
      k.split(".").first
    }

    # if chapter_answered.include?(chapter_number)
    answered_q = question_database.filter { |question|
      cod = question.dig(:question, :cod)
      answered[cod] and answered[cod].size < 3
    }
    pp answered_q
    not_answered_q = question_database.filter { |question|
      cod = question.dig(:question, :cod)
      !answered[cod]
    }
    answered_res = answered_q.sample(4)
    new_q_num = 10 - answered_res.size
    not_answered_res = not_answered_q.sample(new_q_num)
    @ten_question = answered_res + not_answered_res
    render :ten_question, status: :ok
  end

  def answered
    # answered_new = params.dig(:question, :questions)
    answered_new = params.dig(:question)
    current_user
    answered_old = @current_user.answered
    keys_p = answered_new.keys
    answered_new_hash = answered_new.permit(keys_p).to_h
    answered_new_hash.map { |key, value|
      old_value = answered_old[key]
      if old_value and value == "1"
        answered_old[key] = old_value + value
        answered_new_hash.delete(key)
      end
    }

    res = answered_new_hash.merge(answered_old)
    @current_user.answered = res
    @current_user.save
    # pp @current_user
  end

  def statistics_reset
    current_user
    @current_user.answered = {}
    @current_user.save
    # pp @current_user.answered
  end

  def exam
    question_database = XlsxToJson.get_database("public/fsfr_questions_and_answers.xlsx") 
    group_q = question_database.group_by { |q|
      q.dig(:chapter, :number)
    }
    ch_num_size = group_q.keys.map { |key|
      chapter_size = group_q[key].size
      chapter_num = group_q[key].first.dig(:chapter, :number)
      [chapter_num, chapter_size]
    }
    question_amount = ch_num_size.inject(0) { |sum, x| sum + x[1] }
    questions = ch_num_size.map { |num, sz|
      procent = sz * 100 / question_amount
      questions_part = group_q[num].sample(procent)
      questions_part
    }
    main_part = questions.flatten
    remain_part = question_database.sample(100 - questions.flatten.size)
    @sample_100_question = main_part + remain_part
    render
  end

  def studying
    question_database = XlsxToJson.get_database("public/fsfr_questions_and_answers.xlsx")
    @one_question = question_database.sample(1)
    render
  end
end
