package dao;

import java.sql.*;

import model.Order;
import model.User;

public class UserDao {
	private Connection con;

	private String query;
    private PreparedStatement pst;
    private ResultSet rs;

	public UserDao(Connection con) {
		this.con = con;
	}
	
	public User userLogin(String email, String password) {
		User user = null;
        try {
            query = "select * from users where email=? and password=?";
            pst = this.con.prepareStatement(query);
            pst.setString(1, email);
            pst.setString(2, password);
            rs = pst.executeQuery();
            if(rs.next()){
            	user = new User();
            	user.setId(rs.getInt("id"));
            	user.setName(rs.getString("name"));
            	user.setEmail(rs.getString("email"));
            }
        } catch (SQLException e) {
            System.out.print(e.getMessage());
        }
        return user;
    }
	public String retrievePassword(String email) {
		try {
			query = "select * from users where email=?";
			pst = this.con.prepareStatement(query);
			pst.setString(1, email);
			rs = pst.executeQuery();
			if(rs.next()){
				return rs.getString("password");
			}
		} catch (SQLException e) {
			System.out.print(e.getMessage());
		}
		return null;
	}
	public boolean insertUser(String name, String email, String password) {
        boolean result = false;
        try {
            query = "insert into users (name, email, password) values(?,?,?)";
            pst = this.con.prepareStatement(query);
            pst.setString(1, name);
            pst.setString(2, email);
            pst.setString(3, password);
            pst.executeUpdate();
            result = true;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return result;
    }
}
