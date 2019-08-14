require "simple_xlsx_reader"

module XlsxToJson
  def self.get_database(file)
    doc = SimpleXlsxReader.open(file)
    # doc.sheets
    # doc.sheets.first.name
    # pp doc.sheets.first.rows.take(10)

    e = nil
    d = nil
    c = nil
    headers, *answers = doc.sheets.first.rows

    def self.make_json(arr, res_akk)
      return res_akk if arr.empty?

      answer, b, c, d, *tail = arr
      if c.first != nil
        answer, b, *tail = arr
      elsif d.first != nil
        answer, b, c, *tail = arr
      elsif tail.first.first == nil
        answer, b, c, d, e, *tail = arr
      end

      return res_akk if tail.first == [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil]

      #     ["1",
      #   "Рынок ценных бумаг",
      # return res_akk if count == 0
      #   "1",
      #   " Функционирование финансового рынка",
      #   "1",
      #   "Финансовый рынок представляет собой:",
      #   "A.Механизм перераспределения капитала между кредиторами и заемщиками при помощи посредников на основании спроса и предложения на капитал",
      #   "0",
      #   "1.1.1.",
      #   nil],

      # ["№", "ГЛАВА", "№", "ТЕМА", "№", "ВОПРОС", "Ответы", nil, "Код вопроса", nil]
      if c == nil
          answer_hash = { chapter: { number: answer[0],
                                 name: answer[1] },
                       theme: { number: answer[2],
                               name: answer[3] },
                       question: { number: answer[4],
                                  subject: answer[5],
                                  cod: answer[8] },
                       answers: { a: [answer[6], answer[7]],
                                 b: [b[6], b[7]],
                                 c: [],
                                 d: [],
                                 e: [] } }
      elsif d == nil
        answer_hash = { chapter: { number: answer[0],
                                 name: answer[1] },
                       theme: { number: answer[2],
                               name: answer[3] },
                       question: { number: answer[4],
                                  subject: answer[5],
                                  cod: answer[8] },
                       answers: { a: [answer[6], answer[7]],
                                 b: [b[6], b[7]],
                                 c: [c[6], c[7]],
                                 d: [],
                                 e: [] } }
      elsif e == nil
        answer_hash = { chapter: { number: answer[0],
                                 name: answer[1] },
                       theme: { number: answer[2],
                               name: answer[3] },
                       question: { number: answer[4],
                                  subject: answer[5],
                                  cod: answer[8] },
                       answers: { a: [answer[6], answer[7]],
                                 b: [b[6], b[7]],
                                 c: [c[6], c[7]],
                                 d: [d[6], d[7]],
                                 e: [] } }
      else
        answer_hash = { chapter: { number: answer[0],
                                 name: answer[1] },
                       theme: { number: answer[2],
                               name: answer[3] },
                       question: { number: answer[4],
                                  subject: answer[5],
                                  cod: answer[8] },
                       answers: { a: [answer[6], answer[7]],
                                 b: [b[6], b[7]],
                                 c: [c[6], c[7]],
                                 d: [d[6], d[7]],
                                 e: [e[6], e[7]] } }
      end
      make_json(tail, res_akk << answer_hash)
    end

    res = make_json(answers, [])
    #   count = 0
    #   res.take(10).each { |r|
    #     pp count
    #     pp r
    #     count += 1
    #   }

    res.each { |ans|
      pp ans if ans.dig(:chapter, :number) == nil
      # break
    }

    res

    # pp headers
    # pp answers.take(5)

  end
end
