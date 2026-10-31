package com.college.complaint.dao;

import com.college.complaint.model.Category;
import com.college.complaint.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for {@link Category} entities.
 */
public class CategoryDAO {

    // -------------------------------------------------------------------------
    // Helper: map a ResultSet row to a Category object
    // -------------------------------------------------------------------------
    private Category mapRow(ResultSet rs) throws SQLException {
        Category c = new Category();
        c.setCategoryId(rs.getInt("category_id"));
        c.setCategoryName(rs.getString("category_name"));
        c.setDescription(rs.getString("description"));
        return c;
    }

    // -------------------------------------------------------------------------
    // getAllCategories
    // -------------------------------------------------------------------------

    /**
     * Returns all complaint categories ordered by name.
     *
     * @return list of all categories
     * @throws SQLException on database error
     */
    public List<Category> getAllCategories() throws SQLException {
        String sql = "SELECT * FROM categories ORDER BY category_name";
        List<Category> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } finally {
            DBConnection.closeResources(conn, ps, rs);
        }
        return list;
    }

    // -------------------------------------------------------------------------
    // getCategoryById
    // -------------------------------------------------------------------------

    /**
     * Fetches a single category by its primary key.
     *
     * @param id the category ID
     * @return the matching {@link Category}, or {@code null} if not found
     * @throws SQLException on database error
     */
    public Category getCategoryById(int id) throws SQLException {
        String sql = "SELECT * FROM categories WHERE category_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            if (rs.next()) {
                return mapRow(rs);
            }
            return null;
        } finally {
            DBConnection.closeResources(conn, ps, rs);
        }
    }
}
