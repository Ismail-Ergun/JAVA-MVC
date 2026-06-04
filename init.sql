-- Drop tables if they exist to start fresh
DROP TABLE IF EXISTS order_items CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS categories CASCADE;
DROP TABLE IF EXISTS users CASCADE;

-- 1. Users Table
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    address TEXT,
    role VARCHAR(20) NOT NULL CHECK (role IN ('ADMIN', 'CUSTOMER')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Categories Table
CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    is_active BOOLEAN DEFAULT TRUE
);

-- 3. Products Table
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    category_id INT REFERENCES categories(id) ON DELETE RESTRICT,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price NUMERIC(10,2) NOT NULL CHECK (price >= 0),
    stock INT NOT NULL CHECK (stock >= 0),
    image_url VARCHAR(500),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4. Orders Table
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id) ON DELETE CASCADE,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount NUMERIC(10,2) NOT NULL CHECK (total_amount >= 0),
    status VARCHAR(50) NOT NULL CHECK (status IN ('Beklemede', 'Hazırlanıyor', 'Kargoya Verildi', 'Tamamlandı', 'İptal Edildi'))
);

-- 5. Order Items Table
CREATE TABLE order_items (
    id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(id) ON DELETE CASCADE,
    product_id INT REFERENCES products(id) ON DELETE RESTRICT,
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_price NUMERIC(10,2) NOT NULL CHECK (unit_price >= 0),
    subtotal NUMERIC(10,2) NOT NULL CHECK (subtotal >= 0)
);

-- Seed Data
-- Seed Users (passwords are BCrypt hashes of 'admin123' and 'user123')
-- Hash for 'admin123': $2a$10$S8gXyYhBfK/9Z7KjU30fLOD/a5n5rQYv6vT5eK77h0k0gQ2Fk2G2m
-- Hash for 'user123': $2a$10$w8.22E5F2f2tZ9jL1d3c1eG2H3o0Fv5tY6vT5eK77h0k0gQ2Fk2G2m
INSERT INTO users (full_name, email, password, phone, address, role) VALUES
('Sistem Yöneticisi', 'admin@ecommerce.com', '$2a$10$FN21djbzuPrnHqBY3uQLm.0tm6Hhth.KvQQ5rPpR1RqYcZh3uhMr6', '05555555555', 'E-Ticaret Yönetim Merkezi', 'ADMIN'),
('Furkan Tekiroğlu', 'user@ecommerce.com', '$2a$10$xLkS0aoHlk0DotvhEHR.FeiJGISnz51rgvhc9qHyiPMpbh1.7OKOe', '05444444444', 'Kadıköy, İstanbul', 'CUSTOMER');

-- Seed Categories
INSERT INTO categories (name, description, is_active) VALUES
('Telefon', 'Akıllı telefonlar ve aksesuarları', TRUE),
('Bilgisayar', 'Dizüstü ve masaüstü bilgisayarlar', TRUE),
('Aksesuar', 'Kulaklık, klavye, mouse ve diğer donanımlar', TRUE),
('Kitap', 'Yazılım, tasarım ve kişisel gelişim kitapları', TRUE),
('Giyim', 'Erkek ve kadın spor/günlük giyim ürünleri', TRUE);

-- Seed Products
INSERT INTO products (category_id, name, description, price, stock, image_url, is_active) VALUES
(1, 'iPhone 15 Pro Max', '256 GB Titanyum akıllı telefon, yüksek performanslı A17 Pro çip.', 74999.00, 15, 'https://images.unsplash.com/photo-1695048133142-1a20484d2569?auto=format&fit=crop&w=600&q=80', TRUE),
(1, 'Samsung Galaxy S24 Ultra', '512 GB Titanyum Gri, entegre S-Pen ile birlikte yapay zeka özellikli.', 68999.00, 10, 'https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?auto=format&fit=crop&w=600&q=80', TRUE),
(2, 'MacBook Pro M3 Max', '16 inç Uzay Siyahı, 36 GB RAM, 1 TB SSD, üstün performans.', 112999.00, 5, 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?auto=format&fit=crop&w=600&q=80', TRUE),
(2, 'Dell XPS 15', 'Intel Core i9, 32 GB RAM, NVIDIA RTX 4060, OLED Dokunmatik Ekran.', 84999.00, 8, 'https://images.unsplash.com/photo-1593642632823-8f785ba67e45?auto=format&fit=crop&w=600&q=80', TRUE),
(3, 'AirPods Pro (2. Nesil)', 'Aktif Gürültü Engelleme özellikli kablosuz kulaklık.', 8499.00, 50, 'https://images.unsplash.com/photo-1588449668365-d15e397f6787?auto=format&fit=crop&w=600&q=80', TRUE),
(3, 'Logitech MX Master 3S', 'Gelişmiş kablosuz ergonomik fare, yüksek hassasiyetli sensör.', 3899.00, 30, 'https://images.unsplash.com/photo-1615663245857-ac93bb7c39e7?auto=format&fit=crop&w=600&q=80', TRUE),
(4, 'Java: The Complete Reference', 'Java 17 & 21 konularını kapsayan kapsamlı başvuru kılavuzu.', 890.00, 25, 'https://images.unsplash.com/photo-1589829545856-d10d557cf95f?auto=format&fit=crop&w=600&q=80', TRUE),
(4, 'Clean Code: A Handbook of Agile Software Craftsmanship', 'Robert C. Martin tarafından yazılmış temiz kod yazma rehberi.', 720.00, 0, 'https://images.unsplash.com/photo-1532012197267-da84d127e765?auto=format&fit=crop&w=600&q=80', TRUE),
(5, 'Siyah Kapüşonlu Sweatshirt', 'Pamuklu kumaş, rahat kesim, unisex günlük sweatshirt.', 699.00, 100, 'https://images.unsplash.com/photo-1556821840-3a63f95609a7?auto=format&fit=crop&w=600&q=80', TRUE),
(5, 'Oversize Denim Ceket', 'Klasik mavi denim ceket, şık ve dayanıklı.', 1299.00, 40, 'https://images.unsplash.com/photo-1576995853123-5a10305d93c0?auto=format&fit=crop&w=600&q=80', TRUE);
