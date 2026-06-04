package com.ecommerce.dao;

import com.ecommerce.model.Order;
import com.ecommerce.model.OrderItem;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {

    public boolean createOrder(Order order) {
        String insertOrderSQL = "INSERT INTO orders (user_id, total_amount, status) VALUES (?, ?, ?)";
        String insertItemSQL = "INSERT INTO order_items (order_id, product_id, quantity, unit_price, subtotal) VALUES (?, ?, ?, ?, ?)";
        String checkStockSQL = "SELECT stock FROM products WHERE id = ? FOR UPDATE";
        String updateStockSQL = "UPDATE products SET stock = stock - ? WHERE id = ?";

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Start transaction

            int orderId = -1;
            // 1. Insert order record
            try (PreparedStatement orderStmt = conn.prepareStatement(insertOrderSQL, Statement.RETURN_GENERATED_KEYS)) {
                orderStmt.setInt(1, order.getUserId());
                orderStmt.setDouble(2, order.getTotalAmount());
                orderStmt.setString(3, order.getStatus() != null ? order.getStatus() : "Beklemede");
                
                int rows = orderStmt.executeUpdate();
                if (rows == 0) {
                    throw new SQLException("Creating order failed, no rows affected.");
                }

                try (ResultSet generatedKeys = orderStmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        orderId = generatedKeys.getInt(1);
                    } else {
                        throw new SQLException("Creating order failed, no ID obtained.");
                    }
                }
            }

            // 2. Process each item
            try (PreparedStatement checkStockStmt = conn.prepareStatement(checkStockSQL);
                 PreparedStatement updateStockStmt = conn.prepareStatement(updateStockSQL);
                 PreparedStatement itemStmt = conn.prepareStatement(insertItemSQL)) {

                for (OrderItem item : order.getItems()) {
                    // Check stock
                    checkStockStmt.setInt(1, item.getProductId());
                    try (ResultSet rs = checkStockStmt.executeQuery()) {
                        if (rs.next()) {
                            int currentStock = rs.getInt("stock");
                            if (currentStock < item.getQuantity()) {
                                throw new SQLException("Yetersiz stok: Ürün ID " + item.getProductId());
                            }
                        } else {
                            throw new SQLException("Ürün bulunamadı: Ürün ID " + item.getProductId());
                        }
                    }

                    // Deduct stock
                    updateStockStmt.setInt(1, item.getQuantity());
                    updateStockStmt.setInt(2, item.getProductId());
                    updateStockStmt.executeUpdate();

                    // Insert order item
                    itemStmt.setInt(1, orderId);
                    itemStmt.setInt(2, item.getProductId());
                    itemStmt.setInt(3, item.getQuantity());
                    itemStmt.setDouble(4, item.getUnitPrice());
                    itemStmt.setDouble(5, item.getSubtotal());
                    itemStmt.executeUpdate();
                }
            }

            conn.commit(); // Commit transaction if all succeeded
            order.setId(orderId);
            return true;

        } catch (SQLException e) {
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback(); // Rollback transaction on failure
                } catch (SQLException rollbackEx) {
                    rollbackEx.printStackTrace();
                }
            }
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException closeEx) {
                    closeEx.printStackTrace();
                }
            }
        }
        return false;
    }

    public List<Order> getOrdersByUserId(int userId) {
        List<Order> list = new ArrayList<>();
        String query = "SELECT id, user_id, order_date, total_amount, status FROM orders WHERE user_id = ? ORDER BY order_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(new Order(
                        rs.getInt("id"),
                        rs.getInt("user_id"),
                        rs.getTimestamp("order_date"),
                        rs.getDouble("total_amount"),
                        rs.getString("status")
                    ));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Order> getAllOrders() {
        List<Order> list = new ArrayList<>();
        String query = "SELECT o.id, o.user_id, u.full_name AS customer_name, o.order_date, o.total_amount, o.status " +
                       "FROM orders o " +
                       "JOIN users u ON o.user_id = u.id " +
                       "ORDER BY o.order_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Order order = new Order(
                    rs.getInt("id"),
                    rs.getInt("user_id"),
                    rs.getTimestamp("order_date"),
                    rs.getDouble("total_amount"),
                    rs.getString("status")
                );
                order.setCustomerName(rs.getString("customer_name"));
                list.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Order getOrderById(int orderId) {
        String orderQuery = "SELECT o.id, o.user_id, u.full_name AS customer_name, o.order_date, o.total_amount, o.status " +
                            "FROM orders o " +
                            "JOIN users u ON o.user_id = u.id " +
                            "WHERE o.id = ?";
        
        String itemsQuery = "SELECT oi.id, oi.order_id, oi.product_id, p.name AS product_name, oi.quantity, oi.unit_price, oi.subtotal " +
                            "FROM order_items oi " +
                            "JOIN products p ON oi.product_id = p.id " +
                            "WHERE oi.order_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement orderStmt = conn.prepareStatement(orderQuery);
             PreparedStatement itemsStmt = conn.prepareStatement(itemsQuery)) {
            
            orderStmt.setInt(1, orderId);
            try (ResultSet rs = orderStmt.executeQuery()) {
                if (rs.next()) {
                    Order order = new Order(
                        rs.getInt("id"),
                        rs.getInt("user_id"),
                        rs.getTimestamp("order_date"),
                        rs.getDouble("total_amount"),
                        rs.getString("status")
                    );
                    order.setCustomerName(rs.getString("customer_name"));

                    // Fetch details
                    itemsStmt.setInt(1, orderId);
                    try (ResultSet rsItems = itemsStmt.executeQuery()) {
                        List<OrderItem> items = new ArrayList<>();
                        while (rsItems.next()) {
                            OrderItem item = new OrderItem(
                                rsItems.getInt("id"),
                                rsItems.getInt("order_id"),
                                rsItems.getInt("product_id"),
                                rsItems.getInt("quantity"),
                                rsItems.getDouble("unit_price"),
                                rsItems.getInt("subtotal")
                            );
                            item.setProductName(rsItems.getString("product_name"));
                            items.add(item);
                        }
                        order.setItems(items);
                    }
                    return order;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateOrderStatus(int orderId, String status) {
        String query = "UPDATE orders SET status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setString(1, status);
            stmt.setInt(2, orderId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Helper for Admin Dashboard Metrics
    public int getTotalProductCount() {
        return getCount("SELECT COUNT(*) FROM products");
    }

    public int getTotalCategoryCount() {
        return getCount("SELECT COUNT(*) FROM categories");
    }

    public int getTotalUserCount() {
        return getCount("SELECT COUNT(*) FROM users");
    }

    public int getTotalOrderCount() {
        return getCount("SELECT COUNT(*) FROM orders");
    }

    public int getPendingOrderCount() {
        return getCount("SELECT COUNT(*) FROM orders WHERE status = 'Beklemede'");
    }

    private int getCount(String query) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}
