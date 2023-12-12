package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Date;
import java.util.Properties;

import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import connection.DbCon;
import dao.UserDao;

/**
 * Servlet implementation class ForgotPassword
 */
@WebServlet("/forgot-password")
public class ForgotPassword extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public ForgotPassword() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String res = "<div style=\"text-align: center; color: green; background-color: #90EE90; font-size: 15px; font-weight: 500; padding: 10px\">\r\n"
				+ "				Password has been sent to email</div>";
		String resError = "<div style=\"text-align: center; color: #900D09; background-color: #BC544B; font-size: 15px; font-weight: 500; padding: 10px\">\r\n"
				+ "				Gmail wasn't registered</div>";
		final String emailServer = "echnon3@gmail.com";
		final String password = "akbezmcdpcupsqmq";
		String emailClient = request.getParameter("email");
		Properties prop = new Properties();
		prop.put("mail.smtp.host", "smtp.gmail.com");
		prop.put("mail.smtp.port", "587");
		prop.put("mail.smtp.auth", "true");
		prop.put("mail.smtp.starttls.enable", "true");
		Authenticator auth = new Authenticator() {
			@Override
			protected PasswordAuthentication getPasswordAuthentication() {
				return new PasswordAuthentication(emailServer, password);
			}
		};
		Session session = Session.getInstance(prop, auth);
		Connection connection;
		try {
			connection = DbCon.getConnection();
			UserDao dao = new UserDao(connection);
			String passwordClient = dao.retrievePassword(emailClient);
			if(passwordClient==null) {
				request.setAttribute("resError", resError);
				request.getRequestDispatcher("forgotPassword.jsp").forward(request, response);
			}
			MimeMessage msg = new MimeMessage(session);
			
			try {
				msg.addHeader("Content-type", "text/html; charset=utf-8");
				msg.setFrom(emailServer);
				msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(emailClient, false));
				msg.setSubject("Retrieve password!");
				msg.setSentDate(new Date());
				msg.setText("Your password is "+passwordClient , "UTF-8");
				Transport.send(msg);
				System.out.println("Gửi email thành công");
				request.setAttribute("res", res);
				request.getRequestDispatcher("login.jsp").forward(request, response);
			} catch (MessagingException e) {
				e.printStackTrace();
				System.out.println("Gửi email thất bại");
			}
			
		} catch (ClassNotFoundException | SQLException e) {
			e.printStackTrace();
		};
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
