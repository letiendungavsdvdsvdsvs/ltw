package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import connection.DbCon;
import dao.UserDao;
import model.User;

/**
 * Servlet implementation class Register
 */
@WebServlet("/register")
public class Register extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Register() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String resSuccess = "<div style=\"text-align: center; color: green; background-color: #90EE90; font-size: 15px; font-weight: 500; padding: 10px\">\r\n"
				+ "				Register succeed! Please login</div>";
		String name = request.getParameter("name");
		String email = request.getParameter("email");
		String password = request.getParameter("password");
		try {
			UserDao dao = new UserDao(DbCon.getConnection());
			boolean result = dao.insertUser(name, email, password);
			if(result) {
				request.setAttribute("resSuccess", resSuccess);
				request.getRequestDispatcher("login.jsp").forward(request, response);
			}else {
				request.getRequestDispatcher("register.jsp").forward(request, response);
			}
		} catch (ClassNotFoundException | SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}

}
