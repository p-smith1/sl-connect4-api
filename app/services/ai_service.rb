class AiService
  def initialize board_service
    @board_service = board_service
  end

  def get_best_move
    beta = BoardService::MAX_WIDTH * BoardService::MAX_HEIGHT / 2
    alpha = -beta

    get_move alpha, beta
  end

  def get_weak_move
    get_move -1, 1
  end

  private

  def get_move alpha, beta
    column_score = negamax alpha, beta

    @board_service.reset

    column_score[0]
  end

  def negamax alpha, beta
    return [-1, 0] if @board_service.move_count == BoardService::MAX_WIDTH * BoardService::MAX_HEIGHT

    alpha_value = alpha.kind_of?(Array) ? alpha[1] : alpha
    beta_value = beta.kind_of?(Array) ? beta[1] : beta

    for column_index in 0...BoardService::MAX_WIDTH do
      if @board_service.is_playable?(column_index) &&
         @board_service.is_winning_move?(column_index)
        score = (BoardService::MAX_WIDTH * BoardService::MAX_HEIGHT + 1 - @board_service.move_count) / 2
        return [column_index, score]
      end
    end

    max_score = (BoardService::MAX_WIDTH * BoardService::MAX_HEIGHT - 1 - @board_service.move_count) / 2

    if beta_value > max_score
      beta_value = max_score

      if alpha_value >= beta_value
        return beta.kind_of?(Array) ? [beta[0], beta_value] : [-1, beta_value]
      end

      return [-1, beta_value] if alpha_value >= beta_value
    end

    for column_index in 0...BoardService::MAX_WIDTH do
      if @board_service.is_playable? column_index
        @board_service.play column_index
        
        column_score = negamax(-beta_value, -alpha_value)

        return column_score if column_score[1] >= beta_value

        if column_score[1] > alpha_value
          alpha = column_score
        end
      end
    end

    return alpha.kind_of?(Array) ? alpha : [-1, alpha]
  end
end
