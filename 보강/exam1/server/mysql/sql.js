module.exports = {
    boardList : `SELECT b.no, b.title, b.writer, b.content, b.created_date, b.updated_date, COUNT(c.no)  as comment
                 FROM t_board_board b LEFT OUTER JOIN t_comment_board c
                                      ON b.no = c.bno                
                GROUP by b.no, b.title, b.writer, b.content, b.created_date, b.updated_date`,
    boardInfo : `SELECT no, title, writer, content, created_date, updated_date, (SELECT COUNT(no) FROM t_comment_board WHERE bno = t_board_board.no) as comment
                FROM t_board_board
                WHERE no = ?`    ,
    boardInsert : `INSERT INTO t_board_board SET ? `,
    boardUpdate : `UPDATE t_board_board SET ? WHERE no = ? `
}