USE WINMART;
GO
------TẠO BẢNG------
-- 1. Bảng Chức Vụ
CREATE TABLE dbo.tbl_ChucVu
(
    MaCV    VARCHAR(15)  NOT NULL,-- Mã chức vụ, duy nhất cho mỗi chức vụ
    TenCV   NVARCHAR(100) NOT NULL,      -- Tên chức vụ 

    CONSTRAINT PK_tbl_ChucVu PRIMARY KEY (MaCV),-- Khóa chính bảng Chức vụ
    CONSTRAINT UQ_tbl_ChucVu_TenCV UNIQUE (TenCV)-- Không cho phép trùng tên chức vụ
);
GO
-- 2 Bảng Nhân Viên
CREATE TABLE dbo.tbl_NhanVien
(
    MaNV        VARCHAR(10)   NOT NULL,      -- Mã nhân viên, định danh duy nhất
    HoTenNV     NVARCHAR(100) NOT NULL,      -- Họ tên nhân viên
    GioiTinh    NVARCHAR(10)  NULL,          -- Giới tính (Nam/Nữ), có thể để trống
    DiaChi      NVARCHAR(150) NULL,          -- Địa chỉ nhân viên
    DienThoai   CHAR(10)      NOT NULL,      -- Số điện thoại nhân viên (10 ký tự)
    NgayVaoLam  DATE          NOT NULL,      -- Ngày bắt đầu làm việc
    MaCV        VARCHAR(15)   NOT NULL,      -- Mã chức vụ, liên kết đến bảng Chức vụ

    CONSTRAINT PK_tbl_NhanVien PRIMARY KEY (MaNV),           -- Khóa chính nhân viên
    CONSTRAINT UQ_tbl_NhanVien_DienThoai UNIQUE (DienThoai), -- Không cho phép trùng số điện thoại
    CONSTRAINT FK_tbl_NhanVien_tbl_ChucVu 
        FOREIGN KEY (MaCV) REFERENCES dbo.tbl_ChucVu(MaCV)   -- Ràng buộc khóa ngoại đến Chức vụ
);
GO
-- 3 Bảng Khách Hàng
CREATE TABLE dbo.tbl_KhachHang
(
    MaKH      VARCHAR(10)    NOT NULL,      -- Mã khách hàng, định danh duy nhất
    HoTenKH   NVARCHAR(100)  NOT NULL,      -- Họ tên khách hàng
    DiaChi    NVARCHAR(150)  NULL,          -- Địa chỉ khách hàng
    DienThoai CHAR(10)       NOT NULL,      -- Số điện thoại khách hàng

    CONSTRAINT PK_tbl_KhachHang PRIMARY KEY (MaKH),             -- Khóa chính khách hàng
    CONSTRAINT UQ_tbl_KhachHang_DienThoai UNIQUE (DienThoai)    -- Không cho phép trùng số điện thoại
);
GO
-- 4 Bảng Nhà Cung Cấp
CREATE TABLE dbo.tbl_NhaCungCap
(
    MaNCC      VARCHAR(15)   NOT NULL,      -- Mã nhà cung cấp
    TenNCC     NVARCHAR(100) NOT NULL,      -- Tên nhà cung cấp
    DiaChi     NVARCHAR(150) NULL,          -- Địa chỉ nhà cung cấp
    DienThoai  CHAR(10)      NOT NULL,      -- Số điện thoại nhà cung cấp

    CONSTRAINT PK_tbl_NhaCungCap PRIMARY KEY (MaNCC),              -- Khóa chính nhà cung cấp
    CONSTRAINT UQ_tbl_NhaCungCap_DienThoai UNIQUE (DienThoai)      -- Không cho phép trùng số điện thoại
);
GO
-- 5 Bảng Loại Hàng
CREATE TABLE dbo.tbl_LoaiHang
(
    MaLH   VARCHAR(10)    NOT NULL,      -- Mã loại hàng
    TenLH  NVARCHAR(100)  NOT NULL,      -- Tên loại hàng 

    CONSTRAINT PK_tbl_LoaiHang PRIMARY KEY (MaLH)       -- Khóa chính loại hàng
);
GO
---6 Bảng Mặt Hàng
CREATE TABLE dbo.tbl_MatHang
(
    MaMH        VARCHAR(10)     NOT NULL,       -- Mã mặt hàng
    TenMH       NVARCHAR(150)   NOT NULL,       -- Tên mặt hàng
    GiaBan      DECIMAL(18,2)   NOT NULL,       -- Giá bán hiện tại của sản phẩm
    SoLuongTon  INT             NOT NULL,       -- Số lượng tồn kho hiện tại
    DonViTinh   NVARCHAR(20)    NOT NULL,       -- Đơn vị tính 
    MaLH        VARCHAR(10)     NOT NULL,       -- Mã loại hàng, liên kết đến LOAIHANG
    MaNCC       VARCHAR(15)     NOT NULL,       -- Mã nhà cung cấp, liên kết đến NHACUNGCAP

    CONSTRAINT PK_tbl_MatHang PRIMARY KEY (MaMH),              -- Khóa chính mặt hàng

    CONSTRAINT FK_tbl_MatHang_tbl_LoaiHang
        FOREIGN KEY (MaLH) REFERENCES dbo.tbl_LoaiHang(MaLH),  -- Khóa ngoại đến Loại hàng

    CONSTRAINT FK_tbl_MatHang_tbl_NhaCungCap
        FOREIGN KEY (MaNCC) REFERENCES dbo.tbl_NhaCungCap(MaNCC) -- Khóa ngoại đến Nhà cung cấp
);
GO
-- 7 Bảng Phiếu Nhập
CREATE TABLE dbo.tbl_PhieuNhap
(
    MaPN      VARCHAR(15)    NOT NULL,      -- Mã phiếu nhập
    NgayNhap  DATE           NOT NULL,      -- Ngày nhập hàng
    GhiChu    NVARCHAR(150)  NULL,          -- Ghi chú thêm về phiếu nhập
    MaNV      VARCHAR(10)    NOT NULL,      -- Nhân viên lập phiếu (liên kết NHANVIEN)

    CONSTRAINT PK_tbl_PhieuNhap PRIMARY KEY (MaPN),              -- Khóa chính phiếu nhập

    CONSTRAINT FK_tbl_PhieuNhap_tbl_NhanVien
        FOREIGN KEY (MaNV) REFERENCES dbo.tbl_NhanVien(MaNV)     -- Khóa ngoại đến Nhân viên
);
GO
-- 8 Bảng Chi Tiết Phiếu Nhập
CREATE TABLE dbo.tbl_CTPhieuNhap
(
    MaPN        VARCHAR(15)    NOT NULL,      -- Mã phiếu nhập (liên kết PHIEUNHAP)
    MaMH        VARCHAR(10)    NOT NULL,      -- Mã mặt hàng (liên kết MATHANG)
    SoLuongNhap INT            NOT NULL,      -- Số lượng nhập
    GiaNhap     DECIMAL(18,2)  NOT NULL,      -- Giá nhập cho mặt hàng

    CONSTRAINT PK_tbl_CTPhieuNhap PRIMARY KEY (MaPN, MaMH),          -- Khóa chính kết hợp

    CONSTRAINT FK_tbl_CTPhieuNhap_tbl_PhieuNhap
        FOREIGN KEY (MaPN) REFERENCES dbo.tbl_PhieuNhap(MaPN),       -- Khóa ngoại đến Phiếu nhập

    CONSTRAINT FK_tbl_CTPhieuNhap_tbl_MatHang
        FOREIGN KEY (MaMH) REFERENCES dbo.tbl_MatHang(MaMH)          -- Khóa ngoại đến Mặt hàng
);
GO
-- 9 Bảng Hoá Đơn
CREATE TABLE dbo.tbl_HoaDon
(
    MaHD     VARCHAR(15)    NOT NULL,      -- Mã hóa đơn
    NgayBan  DATE           NOT NULL,      -- Ngày bán hàng
    GhiChu   NVARCHAR(150)  NULL,          -- Ghi chú hóa đơn
    MaNV     VARCHAR(10)    NOT NULL,      -- Nhân viên lập hóa đơn
    MaKH     VARCHAR(10)    NOT NULL,      -- Mã khách hàng mua hàng

    CONSTRAINT PK_tbl_HoaDon PRIMARY KEY (MaHD),               -- Khóa chính hóa đơn

    CONSTRAINT FK_tbl_HoaDon_tbl_NhanVien
        FOREIGN KEY (MaNV) REFERENCES dbo.tbl_NhanVien(MaNV),  -- Khóa ngoại đến Nhân viên

    CONSTRAINT FK_tbl_HoaDon_tbl_KhachHang
        FOREIGN KEY (MaKH) REFERENCES dbo.tbl_KhachHang(MaKH)  -- Khóa ngoại đến Khách hàng
);
GO
-- 10 Bảng Chi Tiết Hoá Đơn
CREATE TABLE dbo.tbl_CTHoaDon
(
    MaHD       VARCHAR(15)    NOT NULL,      -- Mã hóa đơn (liên kết HOADON)
    MaMH       VARCHAR(10)    NOT NULL,      -- Mã mặt hàng (liên kết MATHANG)
    SoLuongBan INT            NOT NULL,      -- Số lượng bán
    GiaBan     DECIMAL(18,2)  NOT NULL,      -- Giá bán của mặt hàng tại thời điểm bán

    CONSTRAINT PK_tbl_CTHoaDon PRIMARY KEY (MaHD, MaMH),            -- Khóa chính kết hợp

    CONSTRAINT FK_tbl_CTHoaDon_tbl_HoaDon
        FOREIGN KEY (MaHD) REFERENCES dbo.tbl_HoaDon(MaHD),         -- Khóa ngoại đến Hóa đơn

    CONSTRAINT FK_tbl_CTHoaDon_tbl_MatHang
        FOREIGN KEY (MaMH) REFERENCES dbo.tbl_MatHang(MaMH)         -- Khóa ngoại đến Mặt hàng
);
GO
-- 11 Bảng Phiếu Xuất
CREATE TABLE dbo.tbl_PhieuXuat
(
    MaPX      VARCHAR(15)    NOT NULL,      -- Mã phiếu xuất
    NgayXuat  DATE           NOT NULL,      -- Ngày xuất kho
    GhiChu    NVARCHAR(150)  NULL,          -- Ghi chú thêm
    MaNV      VARCHAR(10)    NOT NULL,      -- Nhân viên lập phiếu

    CONSTRAINT PK_tbl_PhieuXuat PRIMARY KEY (MaPX),               -- Khóa chính phiếu xuất

    CONSTRAINT FK_tbl_PhieuXuat_tbl_NhanVien
        FOREIGN KEY (MaNV) REFERENCES dbo.tbl_NhanVien(MaNV)      -- Khóa ngoại đến Nhân viên
);
GO
-- 12 Bảng Chi Tiết Phiếu Xuất
CREATE TABLE dbo.tbl_CTPhieuXuat
(
    MaPX        VARCHAR(15)  NOT NULL,      -- Mã phiếu xuất (liên kết PHIEUXUAT)
    MaMH        VARCHAR(10)  NOT NULL,      -- Mã mặt hàng (liên kết MATHANG)
    SoLuongXuat INT          NOT NULL,      -- Số lượng xuất kho

    CONSTRAINT PK_tbl_CTPhieuXuat PRIMARY KEY (MaPX, MaMH),          -- Khóa chính kết hợp

    CONSTRAINT FK_tbl_CTPhieuXuat_tbl_PhieuXuat
        FOREIGN KEY (MaPX) REFERENCES dbo.tbl_PhieuXuat(MaPX),       -- Khóa ngoại đến Phiếu xuất

    CONSTRAINT FK_tbl_CTPhieuXuat_tbl_MatHang
        FOREIGN KEY (MaMH) REFERENCES dbo.tbl_MatHang(MaMH)          -- Khóa ngoại đến Mặt hàng
);
GO
-- 13 Bảng Phiếu Kiểm Kê
CREATE TABLE dbo.tbl_PhieuKiemKe
(
    MaPKK     VARCHAR(15)    NOT NULL,      -- Mã phiếu kiểm kê
    NgayKK    DATE           NOT NULL,      -- Ngày kiểm kê
    GhiChu    NVARCHAR(150)  NULL,          -- Ghi chú về đợt kiểm kê
    MaNV      VARCHAR(10)    NOT NULL,      -- Nhân viên lập phiếu kiểm kê

    CONSTRAINT PK_tbl_PhieuKiemKe PRIMARY KEY (MaPKK),               -- Khóa chính phiếu kiểm kê

    CONSTRAINT FK_tbl_PhieuKiemKe_tbl_NhanVien
        FOREIGN KEY (MaNV) REFERENCES dbo.tbl_NhanVien(MaNV)         -- Khóa ngoại đến Nhân viên
);
GO
-- 14 Bảng Chi Tiết Phiếu Kiểm Kê
CREATE TABLE dbo.tbl_CTPhieuKiemKe
(
    MaPKK          VARCHAR(15)  NOT NULL,    -- Mã phiếu kiểm kê (liên kết PHIEUKIEMKE)
    MaMH           VARCHAR(10)  NOT NULL,    -- Mã mặt hàng (liên kết MATHANG)
    SoLuongNhap    INT          NOT NULL,    -- Tổng số lượng nhập trong kỳ
    SoLuongXuat    INT          NOT NULL,    -- Tổng số lượng xuất trong kỳ
    SoLuongBan     INT          NOT NULL,    -- Số lượng bán trong kỳ
    SoLuongTonQuay INT          NOT NULL,    -- Số lượng tồn tại quầy
    SoLuongTonKho  INT          NOT NULL,    -- Số lượng tồn trong kho

    CONSTRAINT PK_tbl_CTPhieuKiemKe PRIMARY KEY (MaPKK, MaMH),       -- Khóa chính kết hợp

    CONSTRAINT FK_tbl_CTPhieuKiemKe_tbl_PhieuKiemKe
        FOREIGN KEY (MaPKK) REFERENCES dbo.tbl_PhieuKiemKe(MaPKK),   -- Khóa ngoại đến Phiếu kiểm kê

    CONSTRAINT FK_tbl_CTPhieuKiemKe_tbl_MatHang
        FOREIGN KEY (MaMH) REFERENCES dbo.tbl_MatHang(MaMH)          -- Khóa ngoại đến Mặt hàng
);
GO
-------CHÈN DỮ LIỆU----------
-- 1. Chèn dữ liệu bảng Chức Vụ
INSERT INTO dbo.tbl_ChucVu (MaCV, TenCV) VALUES
    ('QL',   N'Quản lý siêu thị'),
    ('NVBH', N'Nhân viên bán hàng'),
    ('NVTN', N'Nhân viên thu ngân'),
    ('NVTK', N'Nhân viên thủ kho');
GO
-- 2. Chèn dữ liệu bảng Nhân Viên
INSERT INTO dbo.tbl_NhanVien 
    (MaNV, HoTenNV, GioiTinh, DiaChi, DienThoai, NgayVaoLam, MaCV) 
VALUES
    ('NV001', N'Nguyễn Văn An',     N'Nam', N'5/1 Đường Nhân Viên, Quận 1, TP.HCM',  '0981232798', '2019-01-01', 'QL'),
    ('NV002', N'Trần Thị Bình',     N'Nữ',  N'10/2 Đường Nhân Viên, Quận 2, TP.HCM', '0981555909', '2019-02-02', 'NVBH'),
    ('NV003', N'Lê Văn Cường',      N'Nam', N'15/3 Đường Nhân Viên, Quận 3, TP.HCM', '0981368765', '2019-03-03', 'NVBH'),
    ('NV004', N'Phạm Thị Dung',     N'Nữ',  N'20/4 Đường Nhân Viên, Quận 4, TP.HCM', '0981434234', '2019-04-04', 'NVTN'),
    ('NV005', N'Hoàng Văn Em',      N'Nam', N'25/5 Đường Nhân Viên, Quận 5, TP.HCM', '0981125690', '2019-05-05', 'NVTN'),
    ('NV006', N'Võ Thị Phương',     N'Nữ',  N'30/6 Đường Nhân Viên, Quận 6, TP.HCM', '0969890765', '2020-06-06', 'NVBH'),
    ('NV007', N'Đỗ Văn Giang',      N'Nam', N'35/7 Đường Nhân Viên, Quận 7, TP.HCM', '0969721157', '2020-07-07', 'NVTK'),
    ('NV008', N'Phan Thị Hạnh',     N'Nữ',  N'40/8 Đường Nhân Viên, Quận 8, TP.HCM', '0989543563', '2020-08-08', 'NVTK'),
    ('NV009', N'Nguyễn Hoài Nam',   N'Nam', N'45/9 Đường Nhân Viên, Quận 9, TP.HCM', '0987655444', '2020-09-09', 'NVBH'),
    ('NV010', N'Trần Khánh Linh',   N'Nữ',  N'50/10 Đường Nhân Viên, Quận 10, TP.HCM','0989111909','2020-10-10', 'NVTN'),
    ('NV011', N'Lê Thị Mai',        N'Nữ',  N'55/11 Đường Nhân Viên, Quận 11, TP.HCM','0965432431','2021-01-11', 'NVBH'),
    ('NV012', N'Phạm Văn Nhật',     N'Nam', N'60/12 Đường Nhân Viên, Quận 12, TP.HCM','0979679879','2021-02-12', 'NVTK'),
    ('NV013', N'Đặng Thị Oanh',     N'Nữ',  N'65/13 Đường Nhân Viên, Quận 1, TP.HCM', '0979978976','2021-03-13', 'NVTN'),
    ('NV014', N'Huỳnh Văn Phúc',    N'Nam', N'70/14 Đường Nhân Viên, Quận 2, TP.HCM', '0357683579','2021-04-14', 'NVBH'),
    ('NV015', N'Ngô Thị Quỳnh',     N'Nữ',  N'75/15 Đường Nhân Viên, Quận 3, TP.HCM', '0819495493','2021-05-15', 'NVBH'),
    ('NV016', N'Bùi Văn Sơn',       N'Nam', N'80/16 Đường Nhân Viên, Quận 4, TP.HCM', '0913698696','2021-06-16', 'NVTK'),
    ('NV017', N'Đoàn Thị Trang',    N'Nữ',  N'85/17 Đường Nhân Viên, Quận 5, TP.HCM', '0845345289','2021-07-17', 'NVTN'),
    ('NV018', N'Trịnh Văn Việt',    N'Nam', N'90/18 Đường Nhân Viên, Quận 6, TP.HCM', '0969421969','2021-08-18', 'NVBH'),
    ('NV019', N'Nguyễn Thùy Yên',   N'Nữ',  N'95/19 Đường Nhân Viên, Quận 7, TP.HCM', '0765432191','2021-09-19', 'NVBH'),
    ('NV020', N'Trần Quốc Khánh',   N'Nam', N'100/20 Đường Nhân Viên, Quận 8, TP.HCM','0896342581','2021-10-20', 'NVTK');
GO
-- 3. Chèn dữ liệu bảng Khách Hàng
INSERT INTO dbo.tbl_KhachHang (MaKH, HoTenKH, DiaChi, DienThoai) VALUES
   ('KH001', N'Nguyễn Thị Hoa',  N'3/1 Đường Khách Hàng, Quận 1, TP.HCM',  '0543768793'),
    ('KH002', N'Trần Văn Long',   N'6/2 Đường Khách Hàng, Quận 2, TP.HCM',  '0943278961'),
    ('KH003', N'Lê Thị Hương',    N'9/3 Đường Khách Hàng, Quận 3, TP.HCM',  '0345697643'),
    ('KH004', N'Phạm Văn Bình',   N'12/4 Đường Khách Hàng, Quận 4, TP.HCM', '0978222898'),
    ('KH005', N'Hoàng Thị Lan',   N'15/5 Đường Khách Hàng, Quận 5, TP.HCM', '0876453567'),
    ('KH006', N'Võ Văn Minh',     N'18/6 Đường Khách Hàng, Quận 6, TP.HCM', '0654329893'),
    ('KH007', N'Đỗ Thị Thúy',     N'21/7 Đường Khách Hàng, Quận 7, TP.HCM', '0982479651'),
    ('KH008', N'Phan Văn Thắng',  N'24/8 Đường Khách Hàng, Quận 8, TP.HCM', '0359326578'),
    ('KH009', N'Nguyễn Thị Thu',  N'27/9 Đường Khách Hàng, Quận 9, TP.HCM', '0282598795'),
    ('KH010', N'Trần Văn Dũng',   N'30/10 Đường Khách Hàng, Quận 10, TP.HCM','0981675459'),
    ('KH011', N'Lê Thị Nga',      N'33/11 Đường Khách Hàng, Quận 11, TP.HCM','0976598389'),
    ('KH012', N'Phạm Văn Hậu',    N'36/12 Đường Khách Hàng, Quận 12, TP.HCM','0813493939'),
    ('KH013', N'Hoàng Thị Yến',   N'39/13 Đường Khách Hàng, Quận 1, TP.HCM','0983268765'),
    ('KH014', N'Võ Văn Phú',      N'42/14 Đường Khách Hàng, Quận 2, TP.HCM','0981495495'),
    ('KH015', N'Đỗ Thị Mai',      N'45/15 Đường Khách Hàng, Quận 3, TP.HCM','0814980053'),
    ('KH016', N'Phan Văn Hòa',    N'48/16 Đường Khách Hàng, Quận 4, TP.HCM','0786675675'),
    ('KH017', N'Nguyễn Thị Ly',   N'51/17 Đường Khách Hàng, Quận 5, TP.HCM','0974378897'),
    ('KH018', N'Trần Văn Tâm',    N'54/18 Đường Khách Hàng, Quận 6, TP.HCM','0989909908'),
    ('KH019', N'Lê Thị Thảo',     N'57/19 Đường Khách Hàng, Quận 7, TP.HCM','0981945667'),
    ('KH020', N'Phạm Văn Tú',     N'60/20 Đường Khách Hàng, Quận 8, TP.HCM','0982000676');
GO
-- 4. Chèn dữ liệu bảng Nhà Cung Cấp
INSERT INTO dbo.tbl_NhaCungCap (MaNCC, TenNCC, DiaChi, DienThoai) VALUES
     ('NCC01', N'Công ty CP Sữa Vinamilk', N'10 Đường Nhà Cung Cấp, Quận 1, TP.HCM',  '090010101'),
    ('NCC02', N'Công ty Acecook Việt Nam', N'20 Đường Nhà Cung Cấp, Quận 2, TP.HCM', '090020202'),
    ('NCC03', N'Công ty PepsiCo Việt Nam', N'30 Đường Nhà Cung Cấp, Quận 3, TP.HCM', '090030303'),
    ('NCC04', N'Công ty CP Bibica', N'40 Đường Nhà Cung Cấp, Quận 4, TP.HCM',        '090040404'),
    ('NCC05', N'Công ty Ajinomoto Việt Nam', N'50 Đường Nhà Cung Cấp, Quận 5, TP.HCM', '090050505'),
    ('NCC06', N'Công ty CP Dầu thực vật Tường An', N'60 Đường Nhà Cung Cấp, Quận 6, TP.HCM', '090060606'),
    ('NCC07', N'Công ty CP Việt Nam Kỹ Nghệ Súc Sản (Vissan)', N'70 Đường Nhà Cung Cấp, Quận 7, TP.HCM', '090070707'),
    ('NCC08', N'Công ty CP Masan Consumer', N'80 Đường Nhà Cung Cấp, Quận 8, TP.HCM', '090080808'),
    ('NCC09', N'Công ty CP Thực phẩm Vĩnh Thành Đạt', N'90 Đường Nhà Cung Cấp, Quận 9, TP.HCM', '090090909'),
    ('NCC10', N'Công ty CP Rau quả thực phẩm An Giang', N'100 Đường Nhà Cung Cấp, Quận 10, TP.HCM', '090101010'),
    ('NCC11', N'Công ty TNHH Unilever Việt Nam', N'110 Đường Nhà Cung Cấp, Quận 11, TP.HCM', '090111111'),
    ('NCC12', N'Công ty TNHH Procter & Gamble Việt Nam', N'120 Đường Nhà Cung Cấp, Quận 12, TP.HCM', '090121212'),
    ('NCC13', N'Công ty CP Thực phẩm đông lạnh Hạ Long', N'130 Đường Nhà Cung Cấp, Quận 1, TP.HCM', '090131313'),
    ('NCC14', N'Công ty CP Thực phẩm Á Châu', N'140 Đường Nhà Cung Cấp, Quận 2, TP.HCM', '090141414'),
    ('NCC15', N'Công ty TNHH Nước giải khát Suntory PepsiCo', N'150 Đường Nhà Cung Cấp, Quận 3, TP.HCM', '090151515'),
    ('NCC16', N'Công ty CP Nafoods Group', N'160 Đường Nhà Cung Cấp, Quận 4, TP.HCM', '090161616'),
    ('NCC17', N'Công ty CP Sữa TH True Milk', N'170 Đường Nhà Cung Cấp, Quận 5, TP.HCM', '090171717'),
    ('NCC18', N'Công ty CP Thực phẩm Hữu Nghị', N'180 Đường Nhà Cung Cấp, Quận 6, TP.HCM', '090181818'),
    ('NCC19', N'Công ty CP Dầu ăn Cooking Oil', N'190 Đường Nhà Cung Cấp, Quận 7, TP.HCM', '090191919'),
    ('NCC20', N'Công ty CP Nước khoáng La Vie', N'200 Đường Nhà Cung Cấp, Quận 8, TP.HCM', '090202020');
GO
-- 5. Chèn dữ liệu bảng Loại Hàng
INSERT INTO dbo.tbl_LoaiHang (MaLH, TenLH) VALUES
    ('LH01', N'Sữa và sản phẩm từ sữa'),
    ('LH02', N'Mì ăn liền & thực phẩm khô'),
    ('LH03', N'Nước giải khát'),
    ('LH04', N'Bánh kẹo'),
    ('LH05', N'Gia vị & nước chấm'),
    ('LH06', N'Thực phẩm đông lạnh'),
    ('LH07', N'Rau củ quả tươi'),
    ('LH08', N'Trái cây tươi'),
    ('LH09', N'Hóa mỹ phẩm'),
    ('LH10', N'Đồ gia dụng'),
    ('LH11', N'Mẹ & bé');
GO
-- 6. Chèn dữ liệu bảng Mặt Hàng
INSERT INTO dbo.tbl_MatHang 
    (MaMH, TenMH, GiaBan, SoLuongTon, DonViTinh, MaLH, MaNCC) 
VALUES
   ('MH001', N'Sữa tươi Vinamilk 1L',             32000, 55,  N'Hộp', 'LH01', 'NCC01'),
    ('MH002', N'Sữa chua Vinamilk có đường',        7000, 60,  N'Hộp', 'LH01', 'NCC01'),
    ('MH003', N'Mì Hảo Hảo tôm chua cay',           4500, 65,  N'Gói', 'LH02', 'NCC02'),
    ('MH004', N'Mì Omachi sườn hầm',                7500, 70,  N'Gói', 'LH02', 'NCC02'),
    ('MH005', N'Pepsi lon 330ml',                   9000, 75,  N'Lon', 'LH03', 'NCC03'),
    ('MH006', N'Aquafina 500ml',                    6000, 80,  N'Chai', 'LH03', 'NCC20'),
    ('MH007', N'Bánh ChocoPie hộp 12 cái',          35000, 85,  N'Hộp', 'LH04', 'NCC04'),
    ('MH008', N'Kẹo dẻo thập cẩm',                  18000, 90,  N'Gói', 'LH04', 'NCC04'),
    ('MH009', N'Nước mắm Nam Ngư 900ml',            28000, 95,  N'Chai', 'LH05', 'NCC08'),
    ('MH010', N'Dầu ăn Tường An 1L',                52000, 100, N'Chai', 'LH05', 'NCC06'),
    ('MH011', N'Xúc xích tiệt trùng Vissan',        12000, 105, N'Cây', 'LH06', 'NCC07'),
    ('MH012', N'Cá basa phi lê đông lạnh',          65000, 110, N'Gói', 'LH06', 'NCC13'),
    ('MH013', N'Rau muống bó',                      9000, 115, N'Bó',   'LH07', 'NCC10'),
    ('MH014', N'Cải thìa túi 500g',                 14000, 120, N'Túi', 'LH07', 'NCC10'),
    ('MH015', N'Táo Fuji 1kg',                      68000, 125, N'Kg',  'LH08', 'NCC16'),
    ('MH016', N'Cam sành 1kg',                      38000, 130, N'Kg',  'LH08', 'NCC16'),
    ('MH017', N'Nước rửa chén Sunlight 750ml',      28000, 135, N'Chai','LH09', 'NCC11'),
    ('MH018', N'Bột giặt OMO 3kg',                 125000, 140, N'Túi', 'LH09', 'NCC12'),
    ('MH019', N'Bộ nồi inox 3 cái',                 520000,145, N'Bộ',  'LH10', 'NCC10'),
    ('MH020', N'Tã em bé size M 62 miếng',         320000,150, N'Bịch', 'LH11', 'NCC15');
GO
-- 7. Chèn dữ liệu bảng Phiếu Nhập
INSERT INTO dbo.tbl_PhieuNhap (MaPN, NgayNhap, GhiChu, MaNV) VALUES
    ('PN001', '2023-01-01', N'Lần nhập hàng thứ 1',  'NV001'),
    ('PN002', '2023-02-02', N'Lần nhập hàng thứ 2',  'NV002'),
    ('PN003', '2023-03-03', N'Lần nhập hàng thứ 3',  'NV003'),
    ('PN004', '2023-04-04', N'Lần nhập hàng thứ 4',  'NV004'),
    ('PN005', '2023-05-05', N'Lần nhập hàng thứ 5',  'NV005'),
    ('PN006', '2023-06-06', N'Lần nhập hàng thứ 6',  'NV006'),
    ('PN007', '2023-07-07', N'Lần nhập hàng thứ 7',  'NV007'),
    ('PN008', '2023-08-08', N'Lần nhập hàng thứ 8',  'NV008'),
    ('PN009', '2023-09-09', N'Lần nhập hàng thứ 9',  'NV009'),
    ('PN010', '2023-10-10', N'Lần nhập hàng thứ 10', 'NV010'),
    ('PN011', '2023-11-11', N'Lần nhập hàng thứ 11', 'NV001'),
    ('PN012', '2023-12-12', N'Lần nhập hàng thứ 12', 'NV002'),
    ('PN013', '2023-01-13', N'Lần nhập hàng thứ 13', 'NV003'),
    ('PN014', '2023-02-14', N'Lần nhập hàng thứ 14', 'NV004'),
    ('PN015', '2023-03-15', N'Lần nhập hàng thứ 15', 'NV005'),
    ('PN016', '2023-04-16', N'Lần nhập hàng thứ 16', 'NV006'),
    ('PN017', '2023-05-17', N'Lần nhập hàng thứ 17', 'NV007'),
    ('PN018', '2023-06-18', N'Lần nhập hàng thứ 18', 'NV008'),
    ('PN019', '2023-07-19', N'Lần nhập hàng thứ 19', 'NV009'),
    ('PN020', '2023-08-20', N'Lần nhập hàng thứ 20', 'NV010');
  
GO
-- 8. Chèn dữ liệu bảng Chi Tiết Phiếu Nhập
INSERT INTO dbo.tbl_CTPhieuNhap (MaPN, MaMH, SoLuongNhap, GiaNhap) VALUES
     ('PN001', 'MH001', 52, 25600),
    ('PN002', 'MH002', 54, 5600),
    ('PN003', 'MH003', 56, 3600),
    ('PN004', 'MH004', 58, 6000),
    ('PN005', 'MH005', 60, 7200),
    ('PN006', 'MH006', 62, 4800),
    ('PN007', 'MH007', 64, 28000),
    ('PN008', 'MH008', 66, 14400),
    ('PN009', 'MH009', 68, 22400),
    ('PN010', 'MH010', 70, 41600),
    ('PN011', 'MH011', 72, 9600),
    ('PN012', 'MH012', 74, 52000),
    ('PN013', 'MH013', 76, 7200),
    ('PN014', 'MH014', 78, 11200),
    ('PN015', 'MH015', 80, 54400),
    ('PN016', 'MH016', 82, 30400),
    ('PN017', 'MH017', 84, 22400),
    ('PN018', 'MH018', 86, 100000),
    ('PN019', 'MH019', 88, 416000),
    ('PN020', 'MH020', 90, 256000);
GO
-- 9. Chèn dữ liệu bảng Hóa Đơn
INSERT INTO dbo.tbl_HoaDon (MaHD, NgayBan, GhiChu, MaNV, MaKH) VALUES
   ('HD001', '2024-01-01', N'Hóa đơn bán lẻ số 1',  'NV006', 'KH001'),
    ('HD002', '2024-02-02', N'Hóa đơn bán lẻ số 2',  'NV007', 'KH002'),
    ('HD003', '2024-03-03', N'Hóa đơn bán lẻ số 3',  'NV008', 'KH003'),
    ('HD004', '2024-04-04', N'Hóa đơn bán lẻ số 4',  'NV009', 'KH004'),
    ('HD005', '2024-05-05', N'Hóa đơn bán lẻ số 5',  'NV010', 'KH005'),
    ('HD006', '2024-06-06', N'Hóa đơn bán lẻ số 6',  'NV011', 'KH006'),
    ('HD007', '2024-07-07', N'Hóa đơn bán lẻ số 7',  'NV012', 'KH007'),
    ('HD008', '2024-08-08', N'Hóa đơn bán lẻ số 8',  'NV013', 'KH008'),
    ('HD009', '2024-09-09', N'Hóa đơn bán lẻ số 9',  'NV014', 'KH009'),
    ('HD010', '2024-10-10', N'Hóa đơn bán lẻ số 10', 'NV015', 'KH010'),
    ('HD011', '2024-11-11', N'Hóa đơn bán lẻ số 11', 'NV016', 'KH011'),
    ('HD012', '2024-12-12', N'Hóa đơn bán lẻ số 12', 'NV017', 'KH012'),
    ('HD013', '2024-01-13', N'Hóa đơn bán lẻ số 13', 'NV018', 'KH013'),
    ('HD014', '2024-02-14', N'Hóa đơn bán lẻ số 14', 'NV019', 'KH014'),
    ('HD015', '2024-03-15', N'Hóa đơn bán lẻ số 15', 'NV020', 'KH015'),
    ('HD016', '2024-04-16', N'Hóa đơn bán lẻ số 16', 'NV006', 'KH016'),
    ('HD017', '2024-05-17', N'Hóa đơn bán lẻ số 17', 'NV007', 'KH017'),
    ('HD018', '2024-06-18', N'Hóa đơn bán lẻ số 18', 'NV008', 'KH018'),
    ('HD019', '2024-07-19', N'Hóa đơn bán lẻ số 19', 'NV009', 'KH019'),
    ('HD020', '2024-08-20', N'Hóa đơn bán lẻ số 20', 'NV010', 'KH020');
GO
-- 10. Chèn dữ liệu bảng Chi Tiết Hóa Đơn
INSERT INTO dbo.tbl_CTHoaDon (MaHD, MaMH, SoLuongBan, GiaBan) VALUES
    ('HD001', 'MH001', 2,  32000),
    ('HD002', 'MH002', 3,  7000),
    ('HD003', 'MH003', 4,  4500),
    ('HD004', 'MH004', 5,  7500),
    ('HD005', 'MH005', 1,  9000),
    ('HD006', 'MH006', 2,  6000),
    ('HD007', 'MH007', 3,  35000),
    ('HD008', 'MH008', 4,  18000),
    ('HD009', 'MH009', 5,  28000),
    ('HD010','MH010', 1,  52000),
    ('HD011','MH011', 2,  12000),
    ('HD012','MH012', 3,  65000),
    ('HD013','MH013', 4,  9000),
    ('HD014','MH014', 5,  14000),
    ('HD015','MH015', 1,  68000),
    ('HD016','MH016', 2,  38000),
    ('HD017','MH017', 3,  28000),
    ('HD018','MH018', 4,  125000),
    ('HD019','MH019', 5,  520000),
    ('HD020','MH020', 1,  320000);
GO
-- 11. Chèn dữ liệu bảng Phiếu Xuất
INSERT INTO dbo.tbl_PhieuXuat (MaPX, NgayXuat, GhiChu, MaNV) VALUES
   ('PX001', '2024-01-01', N'Phiếu xuất kho số 1',  'NV004'),
    ('PX002', '2024-02-02', N'Phiếu xuất kho số 2',  'NV005'),
    ('PX003', '2024-03-03', N'Phiếu xuất kho số 3',  'NV006'),
    ('PX004', '2024-04-04', N'Phiếu xuất kho số 4',  'NV007'),
    ('PX005', '2024-05-05', N'Phiếu xuất kho số 5',  'NV008'),
    ('PX006', '2024-06-06', N'Phiếu xuất kho số 6',  'NV009'),
    ('PX007', '2024-07-07', N'Phiếu xuất kho số 7',  'NV010'),
    ('PX008', '2024-08-08', N'Phiếu xuất kho số 8',  'NV011'),
    ('PX009', '2024-09-09', N'Phiếu xuất kho số 9',  'NV012'),
    ('PX010', '2024-10-10', N'Phiếu xuất kho số 10', 'NV013'),
    ('PX011', '2024-11-11', N'Phiếu xuất kho số 11', 'NV014'),
    ('PX012', '2024-12-12', N'Phiếu xuất kho số 12', 'NV015'),
    ('PX013', '2024-01-13', N'Phiếu xuất kho số 13', 'NV016'),
    ('PX014', '2024-02-14', N'Phiếu xuất kho số 14', 'NV017'),
    ('PX015', '2024-03-15', N'Phiếu xuất kho số 15', 'NV018'),
    ('PX016', '2024-04-16', N'Phiếu xuất kho số 16', 'NV019'),
    ('PX017', '2024-05-17', N'Phiếu xuất kho số 17', 'NV020'),
    ('PX018', '2024-06-18', N'Phiếu xuất kho số 18', 'NV004'),
    ('PX019', '2024-07-19', N'Phiếu xuất kho số 19', 'NV005'),
    ('PX020', '2024-08-20', N'Phiếu xuất kho số 20', 'NV006');
GO
-- 12. Chèn dữ liệu bảng Chi Tiết Phiếu Xuất
INSERT INTO dbo.tbl_CTPhieuXuat (MaPX, MaMH, SoLuongXuat) VALUES
   ('PX001', 'MH001', 6),
    ('PX002', 'MH002', 7),
    ('PX003', 'MH003', 8),
    ('PX004', 'MH004', 9),
    ('PX005', 'MH005', 10),
    ('PX006', 'MH006', 11),
    ('PX007', 'MH007', 12),
    ('PX008', 'MH008', 13),
    ('PX009', 'MH009', 14),
    ('PX010', 'MH010', 15),
    ('PX011', 'MH011', 9),
    ('PX012', 'MH012', 10),
    ('PX013', 'MH013', 11),
    ('PX014', 'MH014', 12),
    ('PX015', 'MH015', 13),
    ('PX016', 'MH016', 14),
    ('PX017', 'MH017', 15),
    ('PX018', 'MH018', 9),
    ('PX019', 'MH019', 10),
    ('PX020', 'MH020', 11);
GO
-- 13. Chèn dữ liệu bảng Phiếu Kiểm Kê
INSERT INTO dbo.tbl_PhieuKiemKe (MaPKK, NgayKK, GhiChu, MaNV) VALUES
    ('PKK001', '2024-01-05', N'Phiếu kiểm kê định kỳ lần 1',  'NV002'),
    ('PKK002', '2024-02-05', N'Phiếu kiểm kê định kỳ lần 2',  'NV003'),
    ('PKK003', '2024-03-05', N'Phiếu kiểm kê định kỳ lần 3',  'NV004'),
    ('PKK004', '2024-04-05', N'Phiếu kiểm kê định kỳ lần 4',  'NV005'),
    ('PKK005', '2024-05-05', N'Phiếu kiểm kê định kỳ lần 5',  'NV006'),
    ('PKK006', '2024-06-05', N'Phiếu kiểm kê định kỳ lần 6',  'NV007'),
    ('PKK007', '2024-07-05', N'Phiếu kiểm kê định kỳ lần 7',  'NV008'),
    ('PKK008', '2024-08-05', N'Phiếu kiểm kê định kỳ lần 8',  'NV009'),
    ('PKK009', '2024-09-05', N'Phiếu kiểm kê định kỳ lần 9',  'NV010'),
    ('PKK010', '2024-10-05', N'Phiếu kiểm kê định kỳ lần 10', 'NV011'),
    ('PKK011', '2024-11-05', N'Phiếu kiểm kê định kỳ lần 11', 'NV012'),
    ('PKK012', '2024-12-05', N'Phiếu kiểm kê định kỳ lần 12', 'NV013'),
    ('PKK013', '2024-01-15', N'Phiếu kiểm kê định kỳ lần 13', 'NV014'),
    ('PKK014', '2024-02-15', N'Phiếu kiểm kê định kỳ lần 14', 'NV015'),
    ('PKK015', '2024-03-15', N'Phiếu kiểm kê định kỳ lần 15', 'NV016'),
    ('PKK016', '2024-04-15', N'Phiếu kiểm kê định kỳ lần 16', 'NV017'),
    ('PKK017', '2024-05-15', N'Phiếu kiểm kê định kỳ lần 17', 'NV018'),
    ('PKK018', '2024-06-15', N'Phiếu kiểm kê định kỳ lần 18', 'NV019'),
    ('PKK019', '2024-07-15', N'Phiếu kiểm kê định kỳ lần 19', 'NV020'),
    ('PKK020', '2024-08-15', N'Phiếu kiểm kê định kỳ lần 20', 'NV001');
GO
-- 14. Chèn dữ liệu bảng Chi Tiết Phiếu Kiểm Kê
INSERT INTO dbo.tbl_CTPhieuKiemKe 
    (MaPKK, MaMH, SoLuongNhap, SoLuongXuat, SoLuongBan, SoLuongTonQuay, SoLuongTonKho) 
VALUES
    ('PKK001', 'MH001', 101, 45, 33, 12, 11),
    ('PKK002', 'MH002', 102, 46, 34, 13, 9),
    ('PKK003', 'MH003', 103, 47, 35, 14, 7),
    ('PKK004', 'MH004', 104, 48, 36, 15, 5),
    ('PKK005', 'MH005', 105, 49, 37, 16, 3),
    ('PKK006', 'MH006', 106, 50, 38, 17, 1),
    ('PKK007', 'MH007', 107, 51, 39, 18, 5),
    ('PKK008', 'MH008', 108, 52, 40, 19, 8),
    ('PKK009', 'MH009', 109, 53, 41, 20, 10),
    ('PKK010', 'MH010', 110, 54, 42, 11,  3),
    ('PKK011', 'MH011', 111, 45, 33, 12, 21),
    ('PKK012', 'MH012', 112, 46, 34, 13, 19),
    ('PKK013', 'MH013', 113, 47, 35, 14, 17),
    ('PKK014', 'MH014', 114, 48, 36, 15, 15),
    ('PKK015', 'MH015', 115, 49, 37, 16, 13),
    ('PKK016', 'MH016', 116, 50, 38, 17, 11),
    ('PKK017', 'MH017', 117, 51, 39, 18, 9),
    ('PKK018', 'MH018', 118, 52, 40, 19, 7),
    ('PKK019', 'MH019', 119, 53, 41, 20, 5),
    ('PKK020', 'MH020', 120, 54, 42, 11, 13);
GO
---Tạo User và cấp quyền cho các nhóm người dùng
-- 1. TẠO CÁC LOGIN CẤP SERVER ( QUẢN LÝ, NHÂN VIÊN THU NGÂN, NHÂN VIÊN THỦ KHO)
USE [master];
GO

-- LOGIN Quản lý siêu thị
IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'WinmartManagerUser')
BEGIN
    PRINT N'Đang tạo LOGIN WinmartManagerUser...';
    CREATE LOGIN WinmartManagerUser 
    WITH PASSWORD = 'ManagerWinmart123',
         DEFAULT_DATABASE = [WINMART],
         CHECK_POLICY = OFF;
END
GO

-- LOGIN Nhân viên thu ngân
IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'WinmartCashierUser')
BEGIN
    PRINT N'Đang tạo LOGIN WinmartCashierUser...';
    CREATE LOGIN WinmartCashierUser 
    WITH PASSWORD = 'CashierWinmart123',
         DEFAULT_DATABASE = [WINMART],
         CHECK_POLICY = OFF;
END
GO

-- LOGIN Nhân viên thủ kho
IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'WinmartWarehouseUser')
BEGIN
    PRINT N'Đang tạo LOGIN WinmartWarehouseUser...';
    CREATE LOGIN WinmartWarehouseUser 
    WITH PASSWORD = 'WarehouseWinmart123',
         DEFAULT_DATABASE = [WINMART],
         CHECK_POLICY = OFF;
END
GO
--2. TẠO USER
USE [WINMART];
GO

-- USER Quản lý siêu thị
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'WinmartManagerUser')
BEGIN
    PRINT N'Đang tạo USER WinmartManagerUser...';
    CREATE USER WinmartManagerUser FOR LOGIN WinmartManagerUser;
END
GO

-- USER Nhân viên thu ngân
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'WinmartCashierUser')
BEGIN
    PRINT N'Đang tạo USER WinmartCashierUser...';
    CREATE USER WinmartCashierUser FOR LOGIN WinmartCashierUser;
END
GO

-- USER Nhân viên thủ kho
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'WinmartWarehouseUser')
BEGIN
    PRINT N'Đang tạo USER WinmartWarehouseUser...';
    CREATE USER WinmartWarehouseUser FOR LOGIN WinmartWarehouseUser;
END
GO
--3. TẠO ROLE NGHIỆP VỤ CHO HỆ THỐNG WINMART
--role_WinmartManager: Quản lý siêu thị
--role_WinmartCashier: Nhân viên thu ngân
--role_WinmartWarehouse: Nhân viên thủ kho
USE [WINMART];
GO

-- ROLE Quản lý siêu thị
IF NOT EXISTS (SELECT 1 FROM sys.database_principals 
               WHERE name = 'role_WinmartManager' AND type = 'R')
BEGIN
    PRINT N'Đang tạo ROLE: role_WinmartManager...';
    CREATE ROLE role_WinmartManager;
END
GO

-- ROLE Nhân viên thu ngân
IF NOT EXISTS (SELECT 1 FROM sys.database_principals 
               WHERE name = 'role_WinmartCashier' AND type = 'R')
BEGIN
    PRINT N'Đang tạo ROLE: role_WinmartCashier...';
    CREATE ROLE role_WinmartCashier;
END
GO

-- ROLE Nhân viên thủ kho
IF NOT EXISTS (SELECT 1 FROM sys.database_principals 
               WHERE name = 'role_WinmartWarehouse' AND type = 'R')
BEGIN
    PRINT N'Đang tạo ROLE: role_WinmartWarehouse...';
    CREATE ROLE role_WinmartWarehouse;
END
GO
USE WINMART;
ALTER ROLE role_WinmartManager ADD MEMBER WinmartManagerUser;
ALTER ROLE role_WinmartCashier ADD MEMBER WinmartCashierUser;
ALTER ROLE role_WinmartWarehouse ADD MEMBER WinmartWarehouseUser;
GO
--4. PHÂN QUYỀN CHO CÁC NHÓM NGƯỜI DÙNG
--4.1 PHÂN QUYỀN CHO QUẢN LÝ SIÊU THỊ
PRINT N'Đang cấp quyền cho role_WinmartManager...';

-- Toàn quyền DANH MỤC
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.tbl_ChucVu     TO role_WinmartManager;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.tbl_NhanVien   TO role_WinmartManager;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.tbl_KhachHang  TO role_WinmartManager;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.tbl_NhaCungCap TO role_WinmartManager;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.tbl_LoaiHang   TO role_WinmartManager;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.tbl_MatHang    TO role_WinmartManager;

-- Toàn quyền NGHIỆP VỤ BÁN HÀNG
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.tbl_HoaDon     TO role_WinmartManager;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.tbl_CTHoaDon   TO role_WinmartManager;

-- Toàn quyền NGHIỆP VỤ KHO
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.tbl_PhieuNhap      TO role_WinmartManager;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.tbl_CTPhieuNhap    TO role_WinmartManager;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.tbl_PhieuXuat      TO role_WinmartManager;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.tbl_CTPhieuXuat    TO role_WinmartManager;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.tbl_PhieuKiemKe    TO role_WinmartManager;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.tbl_CTPhieuKiemKe  TO role_WinmartManager;
GO
--4.2 PHÂN QUYỀN CHO NHÂN VIÊN THU NGÂN
PRINT N'Đang cấp quyền cho role_WinmartCashier...';

-- Được xem thông tin sản phẩm, loại hàng
GRANT SELECT ON dbo.tbl_MatHang    TO role_WinmartCashier;
GRANT SELECT ON dbo.tbl_LoaiHang   TO role_WinmartCashier;

-- Được quản lý thông tin khách hàng (đăng ký hội viên)
GRANT SELECT, INSERT, UPDATE 
ON dbo.tbl_KhachHang 
TO role_WinmartCashier;

-- NGHIỆP VỤ BÁN HÀNG: tạo và chỉnh sửa hóa đơn
GRANT SELECT, INSERT, UPDATE 
ON dbo.tbl_HoaDon 
TO role_WinmartCashier;

GRANT SELECT, INSERT, UPDATE 
ON dbo.tbl_CTHoaDon 
TO role_WinmartCashier;
-- Không có quyền DELETE và không được đụng bảng kho
GRANT SELECT ON dbo.tbl_CTHoaDon_Log TO role_WinmartCashier;
-- CÁC VIEW PHỤC VỤ MÀN HÌNH BÁN HÀNG
GRANT SELECT ON dbo.vw_DanhMucSanPham_BanHang   TO role_WinmartCashier;
GRANT SELECT ON dbo.vw_DanhMucSanPham_ConHang   TO role_WinmartCashier;
GRANT SELECT ON dbo.vw_LichSuMuaHang_ChiTiet    TO role_WinmartCashier;
GRANT SELECT ON dbo.vw_CanhBaoTonKho_ThuNgan      TO role_WinmartCashier;
GRANT SELECT ON dbo.vw_HoaDon_CanhBaoBatThuong     TO role_WinmartCashier;
--PHÂN QUYỀN PRODUCE CHO NVTN
GRANT EXECUTE ON dbo.usp_ThuNgan_ThemKhachHangNeuChuaCo TO role_WinmartCashier;
GRANT EXECUTE ON dbo.usp_ThuNgan_LapHoaDonBanHang       TO role_WinmartCashier;
GRANT EXECUTE ON dbo.usp_ThuNgan_TraCuuHoaDon           TO role_WinmartCashier;
GRANT EXECUTE ON dbo.usp_ThuNgan_TinhTien_ThanhToan TO role_WinmartCashier;
GRANT EXECUTE ON dbo.usp_ThuNgan_DoanhThuCaLam      TO role_WinmartCashier;
GO
--4.3 PHÂN QUYỀN CHO NHÂN VIÊN THỦ KHO
PRINT N'Đang cấp quyền cho role_WinmartWarehouse...';
-- XEM danh mục kho
GRANT SELECT ON dbo.tbl_LoaiHang   TO role_WinmartWarehouse;
GRANT SELECT ON dbo.tbl_MatHang    TO role_WinmartWarehouse;
GRANT SELECT ON dbo.tbl_NhaCungCap TO role_WinmartWarehouse;

-- XEM hóa đơn để đối chiếu số lượng bán ra
GRANT SELECT ON dbo.tbl_HoaDon     TO role_WinmartWarehouse;
GRANT SELECT ON dbo.tbl_CTHoaDon   TO role_WinmartWarehouse;

-- NGHIỆP VỤ KHO: nhập – xuất – kiểm kê
GRANT SELECT, INSERT, UPDATE 
ON dbo.tbl_PhieuNhap 
TO role_WinmartWarehouse;

GRANT SELECT, INSERT, UPDATE 
ON dbo.tbl_CTPhieuNhap 
TO role_WinmartWarehouse;

GRANT SELECT, INSERT, UPDATE 
ON dbo.tbl_PhieuXuat 
TO role_WinmartWarehouse;

GRANT SELECT, INSERT, UPDATE 
ON dbo.tbl_CTPhieuXuat 
TO role_WinmartWarehouse;

GRANT SELECT, INSERT, UPDATE 
ON dbo.tbl_PhieuKiemKe 
TO role_WinmartWarehouse;

GRANT SELECT, INSERT, UPDATE 
ON dbo.tbl_CTPhieuKiemKe 
TO role_WinmartWarehouse;

GRANT SELECT ON dbo.vw_Kho_TonKho_HienTai         TO role_WinmartWarehouse;
GRANT SELECT ON dbo.vw_Kho_LichSuNhapHang_ChiTiet TO role_WinmartWarehouse;
GRANT SELECT ON dbo.vw_Kho_LichSuXuatKho_ChiTiet TO role_WinmartWarehouse;
GRANT SELECT ON dbo.vw_Kho_TongHopNhapXuatBan     TO role_WinmartWarehouse;

GRANT EXECUTE ON dbo.usp_ThuKho_TaoPhieuNhapHang          TO role_WinmartWarehouse;
GRANT EXECUTE ON dbo.usp_ThuKho_TaoPhieuXuatKho           TO role_WinmartWarehouse;
GRANT EXECUTE ON dbo.usp_ThuKho_LapPhieuKiemKeTuDong      TO role_WinmartWarehouse;
GRANT EXECUTE ON dbo.usp_ThuKho_TraCuuNhapXuatBan_TheoMatHang TO role_WinmartWarehouse;
GRANT EXECUTE ON dbo.usp_ThuKho_BaoCaoNhapXuatTon_TheoKhoangNgay TO role_WinmartWarehouse;
GRANT EXECUTE ON dbo.usp_ThuKho_DanhSachMatHangCanNhapThem       TO role_WinmartWarehouse;

-- Không được cấp DELETE để đảm bảo lịch sử kho
GO

-- ============================================
-- TẠO SYNONYM CHO CÁC BẢNG NGHIỆP VỤ WINMART
-- ============================================

-- DANH MỤC
CREATE SYNONYM ChucVu        FOR dbo.tbl_ChucVu;
CREATE SYNONYM NhanVien      FOR dbo.tbl_NhanVien;
CREATE SYNONYM KhachHang     FOR dbo.tbl_KhachHang;
CREATE SYNONYM LoaiHang      FOR dbo.tbl_LoaiHang;
CREATE SYNONYM NhaCungCap    FOR dbo.tbl_NhaCungCap;
CREATE SYNONYM MatHang       FOR dbo.tbl_MatHang;

-- HÓA ĐƠN BÁN HÀNG
CREATE SYNONYM HoaDon        FOR dbo.tbl_HoaDon;
CREATE SYNONYM CTHoaDon      FOR dbo.tbl_CTHoaDon;

-- NHẬP KHO
CREATE SYNONYM PhieuNhap     FOR dbo.tbl_PhieuNhap;
CREATE SYNONYM CTPhieuNhap   FOR dbo.tbl_CTPhieuNhap;

-- XUẤT KHO
CREATE SYNONYM PhieuXuat     FOR dbo.tbl_PhieuXuat;
CREATE SYNONYM CTPhieuXuat   FOR dbo.tbl_CTPhieuXuat;

-- KIỂM KÊ KHO
CREATE SYNONYM PhieuKiemKe   FOR dbo.tbl_PhieuKiemKe;
CREATE SYNONYM CTPhieuKiemKe FOR dbo.tbl_CTPhieuKiemKe;


--ỨNG DỤNG ĐỐI VỚI NHÂN VIÊN THU NGÂN - WinmartCashierUser
--1. ỨNG DỤNG VIEW
--VIEW danh mục sản phẩm bán hàng - vw_DanhMucSanPham_BanHang
USE WINMART;
GO

IF OBJECT_ID('dbo.vw_DanhMucSanPham_BanHang', 'V') IS NOT NULL
    DROP VIEW dbo.vw_DanhMucSanPham_BanHang;
GO

CREATE VIEW dbo.vw_DanhMucSanPham_BanHang
AS
SELECT 
    mh.MaMH,
    mh.TenMH,
    lh.TenLH       AS TenLoaiHang,   -- Ví dụ: 'Sữa và sản phẩm từ sữa', 'Bánh kẹo',...
    mh.DonViTinh,
    mh.GiaBan,
    mh.SoLuongTon
FROM dbo.tbl_MatHang AS mh
LEFT JOIN dbo.tbl_LoaiHang AS lh
       ON mh.MaLH = lh.MaLH;
GO
-----TÌNH HUỐNG ỨNG DỤNG---------
--Tình huống 1 – Thu ngân xem nhanh toàn bộ danh mục hàng hóa trước ca làm
--Ví dụ:  thu ngân NV004 – Phạm Thị Dung (chức vụ NVTN) bắt đầu ca sáng, muốn xem nhanh danh mục hàng hóa và giá:
SELECT * FROM dbo.vw_DanhMucSanPham_BanHang;
-- Tình huống 2: Khách hàng KH001 – Nguyễn Thị Hoa đến quầy, hỏi về các sản phẩm thuộc nhóm sữa:
SELECT * 
FROM dbo.vw_DanhMucSanPham_BanHang 
WHERE TenLoaiHang = N'Sữa và sản phẩm từ sữa';
--VIEW chỉ hiển thị sản phẩm còn tồn – vw_DanhMucSanPham_ConHang
USE [WINMART];
GO

IF OBJECT_ID('dbo.vw_DanhMucSanPham_ConHang', 'V') IS NOT NULL
    DROP VIEW dbo.vw_DanhMucSanPham_ConHang;
GO

CREATE VIEW dbo.vw_DanhMucSanPham_ConHang
AS
SELECT 
    mh.MaMH,
    mh.TenMH,
    lh.TenLH       AS TenLoaiHang,
    mh.DonViTinh,
    mh.GiaBan,
    mh.SoLuongTon
FROM dbo.tbl_MatHang AS mh
LEFT JOIN dbo.tbl_LoaiHang AS lh
       ON mh.MaLH = lh.MaLH
WHERE mh.SoLuongTon > 0;
GO
--TÌNH HUỐNG ỨNG DỤNG--
--Tình huống 4 – Khách hỏi “Trái cây hôm nay còn gì?”
SELECT *
FROM dbo.vw_DanhMucSanPham_ConHang
WHERE TenLoaiHang = N'Trái cây tươi';
--VIEW lịch sử mua hàng chi tiết – vw_LichSuMuaHang_ChiTiet
USE [WINMART];
GO

IF OBJECT_ID('dbo.vw_LichSuMuaHang_ChiTiet', 'V') IS NOT NULL
    DROP VIEW dbo.vw_LichSuMuaHang_ChiTiet;
GO

CREATE VIEW dbo.vw_LichSuMuaHang_ChiTiet
AS
SELECT 
    hd.MaHD,
    hd.NgayBan,
    kh.MaKH,
    kh.HoTenKH,
    mh.MaMH,
    mh.TenMH,
    cthd.SoLuongBan,
    cthd.GiaBan,
    (cthd.SoLuongBan * cthd.GiaBan) AS ThanhTien
FROM dbo.tbl_HoaDon    AS hd
JOIN dbo.tbl_KhachHang AS kh ON hd.MaKH = kh.MaKH
JOIN dbo.tbl_CTHoaDon  AS cthd ON hd.MaHD = cthd.MaHD
JOIN dbo.tbl_MatHang   AS mh   ON cthd.MaMH = mh.MaMH;
GO
--TÌNH HUỐNG ỨNG DỤNG
--Xử lý đổi trả theo hóa đơn: Khách KH001 – Nguyễn Thị Hoa quay lại, muốn xem chi tiết lịch sử đã mua
SELECT *
FROM dbo.vw_LichSuMuaHang_ChiTiet
WHERE MaKH = 'KH001'
ORDER BY NgayBan DESC, MaHD;
--VIEW cảnh báo tồn kho cho thu ngân
--Kết hợp tồn kho hiện tại với tổng số lượng đã bán để tạo cột Trạng thái tồn kho.
--Thu ngân nhìn là biết mặt hàng nào “sắp hết” để:
--Chủ động báo lại cho thủ kho / quản lý.
--Giải thích cho khách nếu hàng ít, hạn chế nhận đơn số lượng lớn
USE WINMART;
GO

IF OBJECT_ID('dbo.vw_CanhBaoTonKho_ThuNgan', 'V') IS NOT NULL
    DROP VIEW dbo.vw_CanhBaoTonKho_ThuNgan;
GO

CREATE VIEW dbo.vw_CanhBaoTonKho_ThuNgan
AS
WITH ThongKe AS (
    SELECT 
        mh.MaMH,
        mh.TenMH,
        lh.TenLH AS TenLoaiHang,
        mh.SoLuongTon,
        ISNULL(SUM(ct.SoLuongBan), 0) AS TongSoLuongBan
    FROM dbo.tbl_MatHang AS mh
    LEFT JOIN dbo.tbl_LoaiHang AS lh ON mh.MaLH = lh.MaLH
    LEFT JOIN dbo.tbl_CTHoaDon AS ct ON mh.MaMH = ct.MaMH
    GROUP BY 
        mh.MaMH, mh.TenMH, lh.TenLH, mh.SoLuongTon
)
SELECT 
    MaMH,
    TenMH,
    TenLoaiHang,
    SoLuongTon,
    TongSoLuongBan,
    CASE 
        WHEN SoLuongTon <= 5  THEN N'Rất thấp – cần nhập gấp'
        WHEN SoLuongTon <= 15 THEN N'Thấp – cần theo dõi'
        ELSE N'Vẫn còn hàng'
    END AS TrangThaiTonKho
FROM ThongKe;
GO
SELECT *
FROM dbo.vw_CanhBaoTonKho_ThuNgan
WHERE TrangThaiTonKho <> N'Rất thấp – cần nhập gấp'
ORDER BY SoLuongTon ASC;
--VIEW “Cảnh báo hóa đơn bất thường cho thu ngân” -vw_HoaDon_CanhBaoBatThuong
--Tính tổng tiền & tổng số lượng của từng hóa đơn.
--Tính trung bình toàn hệ thống.
--Nếu hóa đơn nào có tổng tiền / tổng số lượng ≥ 2 lần trung bình → đánh dấu “Hóa đơn lớn – cần báo quản lý”.
--Đây là dạng phân tích rủi ro,giúp thu ngân nhận biết đơn quá lớn để xin xác nhận quản lý (tránh nhầm lẫn, gian lận, quẹt nhầm…).
USE WINMART;
GO

IF OBJECT_ID('dbo.vw_HoaDon_CanhBaoBatThuong', 'V') IS NOT NULL
    DROP VIEW dbo.vw_HoaDon_CanhBaoBatThuong;
GO

CREATE VIEW dbo.vw_HoaDon_CanhBaoBatThuong
AS
-- Bước 1: tổng hợp theo hóa đơn
WITH HoaDonTong AS (
    SELECT 
        hd.MaHD,
        hd.NgayBan,
        hd.MaNV,
        nv.HoTenNV,
        hd.MaKH,
        kh.HoTenKH,
        SUM(ct.SoLuongBan)              AS TongSoLuong,
        SUM(ct.SoLuongBan * ct.GiaBan)  AS TongTien
    FROM dbo.tbl_HoaDon   AS hd
    JOIN dbo.tbl_CTHoaDon AS ct ON hd.MaHD = ct.MaHD
    JOIN dbo.tbl_NhanVien AS nv ON hd.MaNV = nv.MaNV
    JOIN dbo.tbl_KhachHang AS kh ON hd.MaKH = kh.MaKH
    GROUP BY 
        hd.MaHD, hd.NgayBan,
        hd.MaNV, nv.HoTenNV,
        hd.MaKH, kh.HoTenKH
),
-- Bước 2: tính trung bình toàn bộ hóa đơn
ThongKe AS (
    SELECT 
        AVG(CAST(TongTien     AS DECIMAL(18,2))) AS TBTongTien,
        AVG(CAST(TongSoLuong  AS DECIMAL(18,2))) AS TBTongSoLuong
    FROM HoaDonTong
)
-- Bước 3: Gắn cờ cảnh báo
SELECT 
    h.MaHD,
    h.NgayBan,
    h.MaNV,
    h.HoTenNV,
    h.MaKH,
    h.HoTenKH,
    h.TongSoLuong,
    h.TongTien,
    CASE 
        WHEN h.TongTien    >= 2 * tk.TBTongTien
          OR h.TongSoLuong >= 2 * tk.TBTongSoLuong
        THEN N'Hóa đơn lớn – cần báo quản lý'
        ELSE N'Bình thường'
    END AS TrangThaiCanhBao
FROM HoaDonTong AS h
CROSS JOIN ThongKe AS tk;
GO
--Cuối ca, thu ngân xem những hóa đơn lớn, bất thường để đối chiếu:
SELECT *
FROM dbo.vw_HoaDon_CanhBaoBatThuong
WHERE TrangThaiCanhBao = N'Hóa đơn lớn – cần báo quản lý'
ORDER BY NgayBan DESC, TongTien DESC;

--2.ỨNG DỤNG INDEX
--INDEX Tăng tốc tìm kiếm sản phẩm theo tên
CREATE NONCLUSTERED INDEX IDX_MatHang_TenMH
ON dbo.tbl_MatHang (TenMH);
GO
--TÌNH HUỐNG ỨNG DỤNG---
---Khách KH001 hỏi: Chị muốn mua táo. Nhân viên xem mặt hàng táo
SELECT * 
FROM dbo.tbl_MatHang
WHERE TenMH LIKE N'sữa%';

--Index– Tối ưu JOIN Hóa đơn ↔ Chi tiết hóa đơn
CREATE NONCLUSTERED INDEX IDX_CTHoaDon_MaHD
ON dbo.tbl_CTHoaDon (MaHD);
GO

--TÌNH HUỐNG ỨNG DỤNG---
SELECT hd.MaHD, hd.NgayBan, kh.HoTenKH, mh.TenMH, cthd.SoLuongBan, cthd.GiaBan
FROM tbl_HoaDon hd
JOIN tbl_CTHoaDon cthd ON hd.MaHD = cthd.MaHD
JOIN tbl_MatHang mh ON mh.MaMH = cthd.MaMH
JOIN tbl_KhachHang kh ON kh.MaKH = hd.MaKH
WHERE hd.MaHD = 'HD010';

--Kiểu bảng chi tiết hóa đơn cho thu ngân
USE [WINMART];
GO

IF TYPE_ID('dbo.HoaDonChiTietType') IS NOT NULL
    DROP TYPE dbo.HoaDonChiTietType;
GO

CREATE TYPE dbo.HoaDonChiTietType AS TABLE
(
    MaMH       VARCHAR(10) NOT NULL, -- Mã mặt hàng
    SoLuongBan INT         NOT NULL  -- Số lượng bán
);
GO
--Thu ngân chọn nhiều mặt hàng trên màn hình bán hàng → ứng dụng gom lại vào 1 biến table type, truyền vào procedure lập hóa đơn.

--3.ỨNG DỤNG PRODUCE 
--PROCEDURE thêm khách hàng mới hoặc lấy lại khách theo số điện thoại - usp_ThuNgan_ThemKhachHangNeuChuaCo
--Nếu số điện thoại đã tồn tại → trả về MaKH hiện có.
--Nếu chưa có → tự sinh mã khách KHxxx, insert mới, rồi trả mã khách vừa tạo
USE [WINMART];
GO

IF OBJECT_ID('dbo.usp_ThuNgan_ThemKhachHangNeuChuaCo', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_ThuNgan_ThemKhachHangNeuChuaCo;
GO

CREATE OR ALTER PROCEDURE dbo.usp_ThuNgan_ThemKhachHangNeuChuaCo
    @HoTenKH    NVARCHAR(100),
    @DiaChi     NVARCHAR(200),
    @DienThoai  VARCHAR(20),
    @MaKH_Moi   VARCHAR(10) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @MaKH VARCHAR(10);

    -- 1. Tìm khách theo số điện thoại
    SELECT @MaKH = MaKH
    FROM dbo.tbl_KhachHang
    WHERE DienThoai = @DienThoai;

    -- 2. Nếu chưa có thì tạo mới
    IF @MaKH IS NULL
    BEGIN
        DECLARE @MaxMaKH VARCHAR(10), @NextNum INT;

        SELECT @MaxMaKH = MAX(MaKH)
        FROM dbo.tbl_KhachHang
        WHERE MaKH LIKE 'KH%';

        IF @MaxMaKH IS NULL
            SET @NextNum = 1;
        ELSE
            SET @NextNum = CAST(SUBSTRING(@MaxMaKH, 3, 3) AS INT) + 1;

        SET @MaKH = 'KH' + RIGHT('000' + CAST(@NextNum AS VARCHAR(3)), 3);

        INSERT INTO dbo.tbl_KhachHang (MaKH, HoTenKH, DiaChi, DienThoai)
        VALUES (@MaKH, @HoTenKH, @DiaChi, @DienThoai);
    END

    -- 3. Trả ra mã khách
    SET @MaKH_Moi = @MaKH;

    SELECT @MaKH AS MaKH, @HoTenKH AS HoTenKH, @DienThoai AS DienThoai;
END
GO
--Bối cảnh dùng: Khi thu ngân đăng ký hội viên nhanh cho khách tại quầy → truyền họ tên, địa chỉ, số điện thoại → procedure tự kiểm tra, tránh tạo trùng, đồng thời trả về MaKH để lập hóa đơn.
--VÍ DỤ 1: Khách đã tồn tại trong CSDL
SELECT MaKH, HoTenKH, DienThoai
FROM dbo.tbl_KhachHang
WHERE MaKH = 'KH001';

--Giả sử thu ngân gọi procedure:
DECLARE @MaKH_Moi VARCHAR(10);

EXEC dbo.usp_ThuNgan_ThemKhachHangNeuChuaCo
    @HoTenKH   = N'Nguyễn Thị Hoa',       
    @DiaChi    = N'3/1 Đường Khách Hàng, Quận 1, TP.HCM',
    @DienThoai = '0543768793',            -- Số đã có trong DB
    @MaKH_Moi  = @MaKH_Moi OUTPUT;

SELECT @MaKH_Moi AS MaKH_DungDeLapHoaDon;
--Procedure nhìn thấy DienThoai = '0543768793' đã tồn tại → không thêm dòng mới
--Biến @MaKH_Moi nhận giá trị: KH001
--Thu ngân dùng MaKH = 'KH001' để lập hóa đơn → tránh trùng khách hàng.

--Ví dụ 2 – Khách mới hoàn toàn
DECLARE @MaKH_Moi VARCHAR(10);

EXEC dbo.usp_ThuNgan_ThemKhachHangNeuChuaCo
    @HoTenKH   = N'Lưu Thị Mỹ Duyên',
    @DiaChi    = N'123 Lê Lợi, Quận 1, TP.HCM',
    @DienThoai = '0909998888',
    @MaKH_Moi  = @MaKH_Moi OUTPUT;

SELECT @MaKH_Moi AS MaKH_Moi_DuocTao;
--Procedure kiểm tra: không tìm thấy DienThoai = '0909998888'
--Lấy MAX(MaKH) hiện tại (ví dụ đang là KH020) → sinh tiếp KH021
--Thêm dòng mới vào tbl_KhachHang: Biến @MaKH_Moi = KH021 để thu ngân dùng lập hóa đơn.

   --PROCEDURE lập hóa đơn bán hàng - usp_ThuNgan_LapHoaDonBanHang
--Kiểm tra: Nhân viên tồn tại, Khách hàng tồn tại, Chi tiết không rỗng, Tồn kho đủ cho từng mặt hàng
--Nếu ok: Sinh mã hóa đơn HDxxx, Insert Hóa đơn + Chi tiết hóa đơn (lấy GiaBan từ tbl_MatHang)
--Trừ tồn kho theo tổng số lượng bán, Tất cả trong transaction, có TRY…CATCH.
USE [WINMART];
GO

IF OBJECT_ID('dbo.usp_ThuNgan_LapHoaDonBanHang', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_ThuNgan_LapHoaDonBanHang;
GO
CREATE OR ALTER PROCEDURE dbo.usp_ThuNgan_LapHoaDonBanHang
    @MaNV       VARCHAR(10),
    @MaKH       VARCHAR(10),
    @GhiChu     NVARCHAR(200) = NULL,
    @NgayBan    DATE = NULL,   -- nếu NULL sẽ lấy ngày hiện tại
    @ChiTiet    dbo.HoaDonChiTietType READONLY,
    @MaHD_Moi   VARCHAR(10) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF @NgayBan IS NULL
        SET @NgayBan = CAST(GETDATE() AS DATE);

    BEGIN TRY
        BEGIN TRAN;

        -- 1. Kiểm tra nhân viên
        IF NOT EXISTS (SELECT 1 FROM dbo.tbl_NhanVien WHERE MaNV = @MaNV)
        BEGIN
            RAISERROR (N'Nhân viên không tồn tại.', 16, 1);
            ROLLBACK TRAN;
            RETURN;
        END

        -- 2. Kiểm tra khách hàng
        IF NOT EXISTS (SELECT 1 FROM dbo.tbl_KhachHang WHERE MaKH = @MaKH)
        BEGIN
            RAISERROR (N'Khách hàng không tồn tại.', 16, 1);
            ROLLBACK TRAN;
            RETURN;
        END

        -- 3. Kiểm tra chi tiết hóa đơn
        IF NOT EXISTS (SELECT 1 FROM @ChiTiet)
        BEGIN
            RAISERROR (N'Chi tiết hóa đơn trống.', 16, 1);
            ROLLBACK TRAN;
            RETURN;
        END

        -- 4. Kiểm tra tồn kho đủ cho từng mặt hàng
        IF EXISTS (
            SELECT 1
            FROM @ChiTiet ct
            JOIN dbo.tbl_MatHang mh ON ct.MaMH = mh.MaMH
            WHERE mh.SoLuongTon < ct.SoLuongBan
        )
        BEGIN
            RAISERROR (N'Số lượng tồn không đủ cho một hoặc nhiều mặt hàng.', 16, 1);
            ROLLBACK TRAN;
            RETURN;
        END

        -- 5. Sinh mã hóa đơn mới HDxxx
        DECLARE @MaxMaHD VARCHAR(10), @NextNum INT;

        SELECT @MaxMaHD = MAX(MaHD)
        FROM dbo.tbl_HoaDon
        WHERE MaHD LIKE 'HD%';

        IF @MaxMaHD IS NULL
            SET @NextNum = 1;
        ELSE
            SET @NextNum = CAST(SUBSTRING(@MaxMaHD, 3, 3) AS INT) + 1;

        SET @MaHD_Moi = 'HD' + RIGHT('000' + CAST(@NextNum AS VARCHAR(3)), 3);

        -- 6. Ghi vào bảng Hóa đơn
        INSERT INTO dbo.tbl_HoaDon (MaHD, NgayBan, GhiChu, MaNV, MaKH)
        VALUES (@MaHD_Moi, @NgayBan, @GhiChu, @MaNV, @MaKH);

        -- 7. Ghi vào Chi tiết hóa đơn (lấy giá bán hiện tại)
        INSERT INTO dbo.tbl_CTHoaDon (MaHD, MaMH, SoLuongBan, GiaBan)
        SELECT 
            @MaHD_Moi,
            ct.MaMH,
            ct.SoLuongBan,
            mh.GiaBan
        FROM @ChiTiet ct
        JOIN dbo.tbl_MatHang mh ON ct.MaMH = mh.MaMH;

        -- 8. Cập nhật tồn kho
        UPDATE mh
        SET mh.SoLuongTon = mh.SoLuongTon - ct.TongSoLuong
        FROM dbo.tbl_MatHang mh
        JOIN (
            SELECT MaMH, SUM(SoLuongBan) AS TongSoLuong
            FROM @ChiTiet
            GROUP BY MaMH
        ) ct ON mh.MaMH = ct.MaMH;

        COMMIT TRAN;

        -- 9. Trả ra thông tin hóa đơn vừa lập
        SELECT 
            hd.MaHD,
            hd.NgayBan,
            hd.GhiChu,
            hd.MaNV,
            hd.MaKH
        FROM dbo.tbl_HoaDon hd
        WHERE hd.MaHD = @MaHD_Moi;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRAN;

        DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity INT;
        SELECT @ErrMsg = ERROR_MESSAGE(),
               @ErrSeverity = ERROR_SEVERITY();

        RAISERROR (@ErrMsg, @ErrSeverity, 1);
    END CATCH
END
GO
--Bối cảnh dùng: Khi thu ngân bấm nút “Thanh toán” 
--trên form bán hàng → ứng dụng gom list hàng vào @ChiTiet, gọi procedure này → hệ thống tự:
--Kiểm tra tồn kho
--Ghi Hóa đơn + Chi tiết hóa đơn
--Trừ tồn kho đúng số lượng

--Chuẩn bị dữ liệu chi tiết hóa đơn (biến table)
--Ví dụ khách mua: 2 hộp Sữa tươi Vinamilk 1L (MH001), 3 gói Mì Hảo Hảo tôm chua cay (MH003)
--Ta dùng type HoaDonBanChiTietType:
DECLARE @ChiTiet dbo.HoaDonChiTietType;

INSERT INTO @ChiTiet (MaMH, SoLuongBan)
VALUES 
    ('MH001', 2),
    ('MH003', 3);
--Hiện tại mặt hàng còn:
SELECT MaMH, TenMH, SoLuongTon
FROM dbo.tbl_MatHang
WHERE MaMH IN ('MH001','MH003');--Đều dư tồn để bán

--Lập hóa đơn mới cho khách KH005, thu ngân NV010
DECLARE @ChiTiet dbo.HoaDonChiTietType;

INSERT INTO @ChiTiet (MaMH, SoLuongBan)
VALUES 
    ('MH001', 2),
    ('MH003', 3);

DECLARE @MaHD_Moi VARCHAR(10);

EXEC dbo.usp_ThuNgan_LapHoaDonBanHang
    @MaNV      = 'NV010',                  -- Thu ngân
    @MaKH      = 'KH005',                  -- Khách hàng Hoàng Thị Lan
    @GhiChu    = N'Hóa đơn mua sữa và mì',
    @NgayBan   = '2024-12-01',             -- Hoặc để NULL = GETDATE()
    @ChiTiet   = @ChiTiet,
    @MaHD_Moi  = @MaHD_Moi OUTPUT;

SELECT @MaHD_Moi AS MaHD_VuaTao;

--Ví dụ bán vượt số lượng tồn
DECLARE @ChiTiet2 dbo.HoaDonChiTietType;

INSERT INTO @ChiTiet2 (MaMH, SoLuongBan)
VALUES ('MH001', 9999);   -- lớn hơn tồn
DECLARE @MaHD_Moi2 VARCHAR(10);

EXEC dbo.usp_ThuNgan_LapHoaDonBanHang
    @MaNV      = 'NV010',
    @MaKH      = 'KH005',
    @GhiChu    = N'HD mua sữa và mì ',
    @NgayBan   = '2024-12-02',
    @ChiTiet   = @ChiTiet2,
    @MaHD_Moi  = @MaHD_Moi2 OUTPUT;

--PROCEDURE tra cứu hóa đơn (in lại / xem lịch sử) - usp_ThuNgan_TraCuuHoaDon
--Cho phép thu ngân tra cứu theo: Mã hóa đơn, Mã khách hàng, Số điện thoại, Khoảng ngày bán
USE [WINMART];
GO

IF OBJECT_ID('dbo.usp_ThuNgan_TraCuuHoaDon', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_ThuNgan_TraCuuHoaDon;
GO
CREATE OR ALTER PROCEDURE dbo.usp_ThuNgan_TraCuuHoaDon
    @MaHD      VARCHAR(10)  = NULL,
    @MaKH      VARCHAR(10)  = NULL,
    @DienThoai VARCHAR(20)  = NULL,
    @NgayTu    DATE         = NULL,
    @NgayDen   DATE         = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        hd.MaHD,
        hd.NgayBan,
        kh.MaKH,
        kh.HoTenKH,
        kh.DienThoai,
        mh.MaMH,
        mh.TenMH,
        cthd.SoLuongBan,
        cthd.GiaBan,
        ThanhTien = cthd.SoLuongBan * cthd.GiaBan
    FROM dbo.tbl_HoaDon    AS hd
    JOIN dbo.tbl_KhachHang AS kh   ON hd.MaKH  = kh.MaKH
    JOIN dbo.tbl_CTHoaDon  AS cthd ON hd.MaHD  = cthd.MaHD
    JOIN dbo.tbl_MatHang   AS mh   ON cthd.MaMH = mh.MaMH
    WHERE (@MaHD      IS NULL OR hd.MaHD      = @MaHD)
      AND (@MaKH      IS NULL OR kh.MaKH      = @MaKH)
      AND (@DienThoai IS NULL OR kh.DienThoai = @DienThoai)
      AND (@NgayTu    IS NULL OR hd.NgayBan  >= @NgayTu)
      AND (@NgayDen   IS NULL OR hd.NgayBan  <= @NgayDen)
    ORDER BY hd.NgayBan DESC, hd.MaHD, mh.TenMH;
END
GO
--Bối cảnh dùng:
--Khách mang hóa đơn đến hỏi lại thông tin → tra theo @MaHD
--Khách chỉ nhớ số điện thoại → tra theo @DienThoai
--cửa hàng yêu cầu kiểm tra hóa đơn trong một ngày → dùng @NgayTu, @NgayDen
 
 --Bối cảnh nghiệp vụ: 
--Một số tình huống tại quầy: Khách mang mã hóa đơn/ảnh chụp → nhờ xem lại chi tiết
--Khách không nhớ mã hóa đơn, chỉ nhớ số điện thoại hoặc tên
--Quản lý yêu cầu xem các hóa đơn trong một khoảng ngày
--Thu ngân không cần join thủ công, chỉ cần dùng: @MaHD khi có mã hóa đơn, @DienThoai khi tra theo số điện thoại
--@NgayTu, @NgayDen để lọc theo ngày
--Ví dụ 1 – Tra cứu chi tiết một hóa đơn (HD010)
SELECT *
FROM dbo.tbl_HoaDon
WHERE MaHD = 'HD010'; -- Trong dữ liệu đã có 

--Thu ngân gọi procedure:
EXEC dbo.usp_ThuNgan_TraCuuHoaDon
    @MaHD = 'HD010',
    @MaKH = NULL,
    @DienThoai = NULL,
    @NgayTu = NULL,
    @NgayDen = NULL;
   
--Ví dụ 2 – Tra cứu lịch sử mua theo số điện thoại khách
EXEC dbo.usp_ThuNgan_TraCuuHoaDon
    @MaHD      = NULL,
    @MaKH      = NULL,
    @DienThoai = '0876453567',
    @NgayTu    = NULL,
    @NgayDen   = NULL;

--PROCEDURE Tính tổng tiền hóa đơn để thanh toán/in bill - usp_ThuNgan_TinhTongTienHoaDon
CREATE OR ALTER PROCEDURE dbo.usp_ThuNgan_TinhTongTienHoaDon
    @MaHD VARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON;

    -- 1. Kiểm tra hóa đơn
    IF NOT EXISTS (SELECT 1 FROM dbo.tbl_HoaDon WHERE MaHD = @MaHD)
    BEGIN
        RAISERROR (N'Hóa đơn không tồn tại.', 16, 1);
        RETURN;
    END;

    -- 2. Trả ra thông tin hóa đơn + tổng tiền
    SELECT
        hd.MaHD,
        hd.NgayBan,
        hd.GhiChu,
        nv.MaNV,
        nv.HoTenNV        AS TenNhanVienBan,
        kh.MaKH,
        kh.HoTenKH,
        kh.DiaChi,
        kh.DienThoai,
        TongTien = SUM(cthd.SoLuongBan * cthd.GiaBan)
    FROM dbo.tbl_HoaDon    hd
    JOIN dbo.tbl_NhanVien  nv   ON hd.MaNV = nv.MaNV
    JOIN dbo.tbl_KhachHang kh   ON hd.MaKH = kh.MaKH
    JOIN dbo.tbl_CTHoaDon  cthd ON hd.MaHD = cthd.MaHD
    WHERE hd.MaHD = @MaHD
    GROUP BY
        hd.MaHD, hd.NgayBan, hd.GhiChu,
        nv.MaNV, nv.HoTenNV,
        kh.MaKH, kh.HoTenKH, kh.DiaChi, kh.DienThoai;
END;
GO
--Ví dụ 1 – Tính tổng tiền hóa đơn HD001
EXEC dbo.usp_ThuNgan_TinhTongTienHoaDon
    @MaHD = 'HD019'; 
--tính tiền thanh toán + tiền thối cho khách - usp_ThuNgan_TinhTien_ThanhToan
--Thu ngân nhập: MaHD, % giảm giá (nếu có), TienKhachDua.
--Procedure:
--Kiểm tra hóa đơn tồn tại
--Tính TongTien từ CTHoaDon
--Tính TienGiam, ThanhToan, TienThoi
--Nếu khách đưa không đủ tiền → báo lỗi.
--Dùng OUTPUT parameter → nâng cao.
USE WINMART;
GO

IF OBJECT_ID('dbo.usp_ThuNgan_TinhTien_ThanhToan', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_ThuNgan_TinhTien_ThanhToan;
GO

CREATE OR ALTER PROCEDURE dbo.usp_ThuNgan_TinhTien_ThanhToan
    @MaHD          VARCHAR(10),
    @PhanTramGiam  DECIMAL(5, 2) = 0,       -- ví dụ 10 = giảm 10%
    @TienKhachDua  DECIMAL(18, 0),
    @TongTien      DECIMAL(18, 0) OUTPUT,
    @TienGiam      DECIMAL(18, 0) OUTPUT,
    @ThanhToan     DECIMAL(18, 0) OUTPUT,
    @TienThoi      DECIMAL(18, 0) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    -- 1. Kiểm tra hóa đơn
    IF NOT EXISTS (SELECT 1 FROM dbo.tbl_HoaDon WHERE MaHD = @MaHD)
    BEGIN
        RAISERROR (N'Hóa đơn không tồn tại.', 16, 1);
        RETURN;
    END

    -- 2. Tính tổng tiền gốc
    SELECT 
        @TongTien = SUM(ct.SoLuongBan * ct.GiaBan)
    FROM dbo.tbl_CTHoaDon ct
    WHERE ct.MaHD = @MaHD;

    IF @TongTien IS NULL
    BEGIN
        RAISERROR (N'Hóa đơn chưa có chi tiết.', 16, 1);
        RETURN;
    END

    -- 3. Tính giảm giá & số tiền phải thanh toán
    SET @TienGiam  = CAST(@TongTien * (@PhanTramGiam / 100.0) AS DECIMAL(18,0));
    SET @ThanhToan = @TongTien - @TienGiam;

    -- 4. Kiểm tra số tiền khách đưa
    IF @TienKhachDua < @ThanhToan
    BEGIN
        RAISERROR (N'Số tiền khách đưa không đủ để thanh toán.', 16, 1);
        RETURN;
    END

    -- 5. Tính tiền thối
    SET @TienThoi = @TienKhachDua - @ThanhToan;

    -- 6. Trả ra 1 dòng tổng hợp (để in bill)
    SELECT
        @MaHD        AS MaHD,
        @TongTien    AS TongTien,
        @PhanTramGiam AS PhanTramGiam,
        @TienGiam    AS TienGiam,
        @ThanhToan   AS ThanhToan,
        @TienKhachDua AS TienKhachDua,
        @TienThoi    AS TienThoi;
END
GO

--Khi bấm “Thanh toán”, form có thể gọi proc này để tính tiền, 
--hiển thị tiền thối cho thu ngân, đồng thời dùng kết quả để in bill.
DECLARE 
    @TongTien   DECIMAL(18,0),
    @TienGiam   DECIMAL(18,0),
    @ThanhToan  DECIMAL(18,0),
    @TienThoi   DECIMAL(18,0);

EXEC dbo.usp_ThuNgan_TinhTien_ThanhToan
    @MaHD         = 'HD010',
    @PhanTramGiam = 5,           -- giảm 5%
    @TienKhachDua = 500000,
    @TongTien     = @TongTien OUTPUT,
    @TienGiam     = @TienGiam OUTPUT,
    @ThanhToan    = @ThanhToan OUTPUT,
    @TienThoi     = @TienThoi OUTPUT;

SELECT @TongTien AS TongTien,
       @TienGiam AS TienGiam,
       @ThanhToan AS ThanhToan,
       @TienThoi AS TienThoi;

--thống kê doanh thu ca làm của thu ngân - usp_ThuNgan_DoanhThuCaLam
--Thu ngân/QL muốn xem kết quả làm việc của 1 thu ngân trong một khoảng ngày (ví dụ trong tháng, hoặc 1 tuần).
--Procedure:
--Nhập @MaNV, @NgayTu, @NgayDen
--Tính số hóa đơn, tổng số lượng bán, tổng doanh thu theo ngày.
--Đây là SP tổng hợp – báo cáo, nhưng vẫn phục vụ trực tiếp cho thu ngân.

USE WINMART;
GO

IF OBJECT_ID('dbo.usp_ThuNgan_DoanhThuCaLam', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_ThuNgan_DoanhThuCaLam;
GO

CREATE OR ALTER PROCEDURE dbo.usp_ThuNgan_DoanhThuCaLam
    @MaNV    VARCHAR(10),
    @NgayTu  DATE,
    @NgayDen DATE
AS
BEGIN
    SET NOCOUNT ON;

    -- 1. Kiểm tra nhân viên
    IF NOT EXISTS (SELECT 1 FROM dbo.tbl_NhanVien WHERE MaNV = @MaNV)
    BEGIN
        RAISERROR (N'Nhân viên không tồn tại.', 16, 1);
        RETURN;
    END

    -- 2. Thống kê theo ngày trong khoảng chọn
    SELECT
        hd.NgayBan,
        nv.MaNV,
        nv.HoTenNV,
        COUNT(DISTINCT hd.MaHD)                 AS SoHoaDon,
        SUM(ct.SoLuongBan)                      AS TongSoLuongBan,
        SUM(ct.SoLuongBan * ct.GiaBan)          AS DoanhThu
    FROM dbo.tbl_HoaDon   hd
    JOIN dbo.tbl_CTHoaDon ct ON hd.MaHD = ct.MaHD
    JOIN dbo.tbl_NhanVien nv ON hd.MaNV = nv.MaNV
    WHERE hd.MaNV = @MaNV
      AND hd.NgayBan BETWEEN @NgayTu AND @NgayDen
    GROUP BY hd.NgayBan, nv.MaNV, nv.HoTenNV
    ORDER BY hd.NgayBan;
END
GO

--Cuối tháng, thu ngân NV010 hoặc quản lý muốn xem tổng kết doanh thu theo ngày cho thu ngân đó.
EXEC dbo.usp_ThuNgan_DoanhThuCaLam
    @MaNV    = 'NV010',         -- Thu ngân
    @NgayTu  = '2024-05-01',
    @NgayDen = '2024-05-31';


--5.ỨNG DỤNG TRIGGER
--Trigger tự động gán Ngày bán nếu để trống
USE [WINMART];
GO

IF OBJECT_ID('dbo.TRG_HoaDon_SetNgayBan_Default', 'TR') IS NOT NULL
    DROP TRIGGER dbo.TRG_HoaDon_SetNgayBan_Default;
GO

CREATE TRIGGER dbo.TRG_HoaDon_SetNgayBan_Default
ON dbo.tbl_HoaDon
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Chỉ cập nhật những hóa đơn mới mà NgayBan đang NULL
    UPDATE hd
    SET hd.NgayBan = CAST(GETDATE() AS DATE)
    FROM dbo.tbl_HoaDon hd
    JOIN inserted i ON hd.MaHD = i.MaHD
    WHERE i.NgayBan IS NULL;
END;
GO ---- ĐÃ XOÁ 

--Trigger nghiệp vụ – Không cho bán vượt số lượng tồn - TRG_CTHoaDon_KiemTraTonKho
USE [WINMART];
GO

IF OBJECT_ID('dbo.TRG_CTHoaDon_KiemTraTonKho', 'TR') IS NOT NULL
    DROP TRIGGER dbo.TRG_CTHoaDon_KiemTraTonKho;
GO

CREATE TRIGGER dbo.TRG_CTHoaDon_KiemTraTonKho
ON dbo.tbl_CTHoaDon
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Nếu có dòng nào bán vượt quá tồn kho hiện tại thì báo lỗi và rollback
    IF EXISTS
    (
        SELECT 1
        FROM inserted i
        JOIN dbo.tbl_MatHang mh ON i.MaMH = mh.MaMH
        WHERE i.SoLuongBan > mh.SoLuongTon
    )
    BEGIN
        RAISERROR (N'Số lượng bán vượt quá số lượng tồn kho hiện tại.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
END;
GO
--Ví dụ 1 – Bán VƯỢT tồn → bị chặn
-- trước tiên thêm HD26 vào bảng Hoá Đơn
INSERT INTO dbo.tbl_HoaDon (MaHD, NgayBan, GhiChu, MaNV, MaKH)
VALUES ('HD22', '2024-12-01', N'Hóa đơn bán lẻ tại quầy', 'NV006', 'KH001');

--Kiểm tra tồn kho hiện tại
SELECT MaMH, TenMH, SoLuongTon
FROM dbo.tbl_MatHang
WHERE MaMH = 'MH001';

--Chèn chi tiết hóa đơn bán VƯỢT tồn để trigger báo lỗi
INSERT INTO dbo.tbl_CTHoaDon (MaHD, MaMH, SoLuongBan, GiaBan)
VALUES ('HD22', 'MH001', 999, 32000);

---Trigger Ghi log khi chỉnh sửa chi tiết hóa đơn - TRG_CTHoaDon_LogThayDoi
--B1: Tạo bảng log
USE [WINMART];
GO

IF OBJECT_ID('dbo.tbl_CTHoaDon_Log', 'U') IS NOT NULL
    DROP TABLE dbo.tbl_CTHoaDon_Log;
GO

CREATE TABLE dbo.tbl_CTHoaDon_Log
(
    LogID          INT IDENTITY(1,1) PRIMARY KEY,
    MaHD           VARCHAR(10),
    MaMH           VARCHAR(10),
    OldSoLuongBan  INT         NULL,
    OldGiaBan      INT         NULL,
    NewSoLuongBan  INT         NULL,
    NewGiaBan      INT         NULL,
    ActionType     NVARCHAR(10),   -- 'UPDATE' hoặc 'DELETE'
    ActionTime     DATETIME,
    ActionUser     SYSNAME
);
GO
--B2: Trigger ghi log
USE [WINMART];
GO

IF OBJECT_ID('dbo.TRG_CTHoaDon_LogThayDoi', 'TR') IS NOT NULL
    DROP TRIGGER dbo.TRG_CTHoaDon_LogThayDoi;
GO

CREATE TRIGGER dbo.TRG_CTHoaDon_LogThayDoi
ON dbo.tbl_CTHoaDon
AFTER UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.tbl_CTHoaDon_Log
    (
        MaHD, MaMH,
        OldSoLuongBan, OldGiaBan,
        NewSoLuongBan, NewGiaBan,
        ActionType,
        ActionTime,
        ActionUser
    )
    SELECT
        ISNULL(d.MaHD, i.MaHD)          AS MaHD,
        ISNULL(d.MaMH, i.MaMH)          AS MaMH,
        d.SoLuongBan                    AS OldSoLuongBan,
        d.GiaBan                        AS OldGiaBan,
        i.SoLuongBan                    AS NewSoLuongBan,
        i.GiaBan                        AS NewGiaBan,
        CASE 
            WHEN i.MaHD IS NULL THEN N'DELETE'
            ELSE N'UPDATE'
        END                             AS ActionType,
        GETDATE()                       AS ActionTime,
        SUSER_SNAME()                   AS ActionUser
    FROM deleted d
    FULL JOIN inserted i
        ON d.MaHD = i.MaHD
       AND d.MaMH = i.MaMH;
END;
GO

-- Ví dụ 1 – Thu ngân sửa số lượng trong chi tiết hóa đơn (UPDATE)
--Giả sử ban đầu chi tiết hóa đơn:
SELECT *
FROM dbo.tbl_CTHoaDon
WHERE MaHD = 'HD001' AND MaMH = 'MH001';

--Thu ngân phát hiện gõ sai, phải là 3 hộp → sửa lại:
UPDATE dbo.tbl_CTHoaDon
SET SoLuongBan = 3
WHERE MaHD = 'HD001' AND MaMH = 'MH001';

--Trigger TRG_CTHoaDon_LogThayDoi chạy và ghi log. Kiểm tra:
SELECT *
FROM dbo.tbl_CTHoaDon_Log
ORDER BY LogID DESC;

--Trigger: Không cho sửa hóa đơn quá ngày (khóa hóa đơn cũ) - TRG_HoaDon_KhoaSuaHoaDonCu
USE [WINMART];
GO

IF OBJECT_ID('dbo.TRG_HoaDon_KhoaSuaHoaDonCu', 'TR') IS NOT NULL
    DROP TRIGGER dbo.TRG_HoaDon_KhoaSuaHoaDonCu;
GO

CREATE TRIGGER dbo.TRG_HoaDon_KhoaSuaHoaDonCu
ON dbo.tbl_HoaDon
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Nếu có hóa đơn nào bị UPDATE mà NgayBan không phải là ngày hiện tại thì chặn
    IF EXISTS
    (
        SELECT 1
        FROM inserted i
        WHERE CAST(i.NgayBan AS DATE) <> CAST(GETDATE() AS DATE)
    )
    BEGIN
        RAISERROR (N'Không được phép chỉnh sửa hóa đơn không thuộc ngày hiện tại.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
END;
GO
--Giả sử bạn sửa ghi chú hóa đơn HD001
UPDATE dbo.tbl_HoaDon
SET GhiChu = N'Sửa ghi chú'
WHERE MaHD = 'HD001';

--Trigger: Cập nhật tổng chi tiêu của khách hàng  khi chi tiết hóa đơn thay đổi - TRG_CTHoaDon_CapNhatTongChiTieu
--Tạo bảng tổng chi tiêu khách hàng
USE [WINMART];
GO

IF OBJECT_ID('dbo.tbl_KhachHang_TongChiTieu', 'U') IS NOT NULL
    DROP TABLE dbo.tbl_KhachHang_TongChiTieu;
GO

CREATE TABLE dbo.tbl_KhachHang_TongChiTieu
(
    MaKH            VARCHAR(10) PRIMARY KEY,      -- Mã khách
    TongSoHoaDon    INT         NOT NULL DEFAULT 0,   -- Tổng số hóa đơn
    TongSoLuongMua  INT         NOT NULL DEFAULT 0,   -- Tổng số lượng hàng đã mua
    TongTienDaMua   BIGINT      NOT NULL DEFAULT 0    -- Tổng tiền khách đã chi
);
GO
USE [WINMART];
GO

IF OBJECT_ID('dbo.TRG_CTHoaDon_CapNhatTongChiTieu', 'TR') IS NOT NULL
    DROP TRIGGER dbo.TRG_CTHoaDon_CapNhatTongChiTieu;
GO

CREATE TRIGGER dbo.TRG_CTHoaDon_CapNhatTongChiTieu
ON dbo.tbl_CTHoaDon
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    /*
        Ý tưởng:
        - inserted  : dữ liệu mới
        - deleted   : dữ liệu cũ
        → Lấy chênh lệch (mới - cũ) theo từng khách hàng
    */

    ;WITH BienDong AS
    (
        SELECT 
            hd.MaKH,
            -- số lượng mới - cũ
            DeltaSoLuong = SUM(
                ISNULL(i.SoLuongBan, 0) - ISNULL(d.SoLuongBan, 0)
            ),
            -- tiền mới - cũ
            DeltaTien = SUM(
                  ISNULL(i.SoLuongBan, 0) * ISNULL(i.GiaBan, 0)
                - ISNULL(d.SoLuongBan, 0) * ISNULL(d.GiaBan, 0)
            ),
            -- số hóa đơn phát sinh mới (chỉ tính INSERT thực sự)
            DeltaSoHoaDon = COUNT(DISTINCT CASE WHEN i.MaHD IS NOT NULL AND d.MaHD IS NULL THEN i.MaHD END)
                            - COUNT(DISTINCT CASE WHEN d.MaHD IS NOT NULL AND i.MaHD IS NULL THEN d.MaHD END)
        FROM inserted i
        FULL JOIN deleted d
             ON i.MaHD = d.MaHD
            AND i.MaMH = d.MaMH
        JOIN dbo.tbl_HoaDon hd 
             ON hd.MaHD = COALESCE(i.MaHD, d.MaHD)
        GROUP BY hd.MaKH
    )
    -- Cập nhật vào bảng tổng chi tiêu
    MERGE dbo.tbl_KhachHang_TongChiTieu AS T
    USING BienDong AS S
       ON T.MaKH = S.MaKH
    WHEN MATCHED THEN
        UPDATE SET
            T.TongSoHoaDon   = T.TongSoHoaDon   + S.DeltaSoHoaDon,
            T.TongSoLuongMua = T.TongSoLuongMua + S.DeltaSoLuong,
            T.TongTienDaMua  = T.TongTienDaMua  + S.DeltaTien
    WHEN NOT MATCHED BY TARGET THEN
        INSERT (MaKH, TongSoHoaDon, TongSoLuongMua, TongTienDaMua)
        VALUES (S.MaKH, 
                CASE WHEN S.DeltaSoHoaDon < 0 THEN 0 ELSE S.DeltaSoHoaDon END,
                CASE WHEN S.DeltaSoLuong   < 0 THEN 0 ELSE S.DeltaSoLuong   END,
                CASE WHEN S.DeltaTien      < 0 THEN 0 ELSE S.DeltaTien      END);
END;
GO
BEGIN TRAN;

    -- Xóa chi tiết hóa đơn trước
    DELETE FROM dbo.tbl_CTHoaDon
    WHERE MaHD IN ('HD023', 'HD024', 'HD22');

    -- Xóa hóa đơn
    DELETE FROM dbo.tbl_HoaDon
    WHERE MaHD IN ('HD023', 'HD024', 'HD22');

COMMIT TRAN;

--Ví dụ minh họa với dữ liệu hiện tại
--B1: Xem tổng chi tiêu của khách KH005 trước khi test
SELECT *
FROM dbo.tbl_KhachHang_TongChiTieu
WHERE MaKH = 'KH005';

--Bước 3: Thu ngân chỉnh sửa số lượng trong chi tiết hóa đơn
--Thu ngân sửa lại từ 3 hộp → 5 hộp:
UPDATE dbo.tbl_CTHoaDon
SET SoLuongBan = 5
WHERE MaHD = 'HD022' AND MaMH = 'MH001';

--Bảng tổng chi tiêu 
SELECT *
FROM dbo.tbl_KhachHang_TongChiTieu
WHERE MaKH = 'KH005';

--Không cho thu ngân GIẢM GIÁ quá mức cho phép - TRG_CTHoaDon_KiemTraGiamGiaToiDa
USE WINMART;
GO

IF OBJECT_ID('dbo.TRG_CTHoaDon_KiemTraGiamGiaToiDa', 'TR') IS NOT NULL
    DROP TRIGGER dbo.TRG_CTHoaDon_KiemTraGiamGiaToiDa;
GO

CREATE TRIGGER dbo.TRG_CTHoaDon_KiemTraGiamGiaToiDa
ON dbo.tbl_CTHoaDon
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    /*
        Điều kiện:
        - Giá bán mới không được thấp hơn 90% giá gốc trong tbl_MatHang
        - Tức giảm tối đa 10%

        -> Nếu vi phạm → rollback & báo lỗi
    */

    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN dbo.tbl_MatHang mh ON i.MaMH = mh.MaMH
        WHERE i.GiaBan < mh.GiaBan * 0.9   -- giảm quá 10%
    )
    BEGIN
        RAISERROR (N'Giá bán giảm vượt quá mức cho phép (10%%). Vui lòng báo quản lý.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
END;
GO
---- Giá gốc MH001 = 32.000
-- Thu ngân cố tình sửa giá còn 20.000
UPDATE dbo.tbl_CTHoaDon
SET GiaBan = 20000
WHERE MaHD = 'HD001' AND MaMH = 'MH001';

--Tự động cập nhật “Doanh thu theo ca” của từng thu ngân - TRG_CTHoaDon_TinhDoanhThuThuNgan
--Khi thu ngân lập hóa đơn → tự sinh dòng doanh thu theo ca vào bảng thống kê.
--Quản lý cuối ngày chỉ cần nhìn bảng này để xác nhận ca.
--Cách làm: 
--Tạo bảng tbl_ThuNgan_DoanhThuCa
--Trigger trên CTHoaDon tính doanh thu hóa đơn
--Gộp vào doanh thu theo ngày & theo thu ngân
CREATE TABLE dbo.tbl_ThuNgan_DoanhThuCa
(
    MaNV         VARCHAR(10),
    NgayBan      DATE,
    SoHoaDon     INT DEFAULT 0,
    TongTien     BIGINT DEFAULT 0,
    PRIMARY KEY (MaNV, NgayBan)
);
GO
--Trigger tính doanh thu ca
USE WINMART;
GO

IF OBJECT_ID('dbo.TRG_CTHoaDon_TinhDoanhThuThuNgan', 'TR') IS NOT NULL
    DROP TRIGGER dbo.TRG_CTHoaDon_TinhDoanhThuThuNgan;
GO

CREATE TRIGGER dbo.TRG_CTHoaDon_TinhDoanhThuThuNgan
ON dbo.tbl_CTHoaDon
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    ;WITH DoanhThu AS (
        SELECT
            hd.MaNV,
            hd.NgayBan,
            SUM(i.SoLuongBan * i.GiaBan) AS TienThem,
            COUNT(DISTINCT i.MaHD)       AS SoHoaDonThem
        FROM inserted i
        JOIN dbo.tbl_HoaDon hd ON i.MaHD = hd.MaHD
        GROUP BY hd.MaNV, hd.NgayBan
    )
    MERGE dbo.tbl_ThuNgan_DoanhThuCa AS T
    USING DoanhThu AS S
       ON T.MaNV = S.MaNV AND T.NgayBan = S.NgayBan
    WHEN MATCHED THEN
        UPDATE SET
            T.SoHoaDon = T.SoHoaDon + S.SoHoaDonThem,
            T.TongTien = T.TongTien + S.TienThem
    WHEN NOT MATCHED THEN
        INSERT (MaNV, NgayBan, SoHoaDon, TongTien)
        VALUES (S.MaNV, S.NgayBan, S.SoHoaDonThem, S.TienThem);
END;
GO
-- Thu ngân NV010 lập hóa đơn mới:
INSERT INTO dbo.tbl_HoaDon (MaHD, NgayBan, GhiChu, MaNV, MaKH)
VALUES ('HD023', GETDATE(), N'Hoá đơn bán lẻ tài quầy ', 'NV010', 'KH005');

INSERT INTO dbo.tbl_CTHoaDon (MaHD, MaMH, SoLuongBan, GiaBan)
VALUES ('HD023', 'MH001', 3, 32000);

SELECT *
FROM dbo.tbl_ThuNgan_DoanhThuCa
WHERE MaNV = 'NV010' AND NgayBan = CAST(GETDATE() AS DATE);

---ỨNG DỤNG ĐỐI VỚI NHÂN VIÊN THỦ KHO 
--1.ỨNG DỤNG VIEW
--View danh mục tồn kho hiện tại - vw_Kho_TonKho_HienTai
USE [WINMART];
GO

IF OBJECT_ID('dbo.vw_Kho_TonKho_HienTai', 'V') IS NOT NULL
    DROP VIEW dbo.vw_Kho_TonKho_HienTai;
GO

CREATE VIEW dbo.vw_Kho_TonKho_HienTai
AS
SELECT 
    mh.MaMH,
    mh.TenMH,
    lh.TenLH              AS TenLoaiHang,
    ncc.TenNCC            AS TenNhaCungCap,
    mh.DonViTinh,
    mh.GiaBan,
    mh.SoLuongTon,
    TrangThaiTon = CASE 
        WHEN mh.SoLuongTon <= 0 THEN N'Hết hàng'
        WHEN mh.SoLuongTon < 20 THEN N'Sắp hết'
        ELSE N'Bình thường'
    END
FROM dbo.tbl_MatHang    AS mh
JOIN dbo.tbl_LoaiHang   AS lh  ON mh.MaLH  = lh.MaLH
JOIN dbo.tbl_NhaCungCap AS ncc ON mh.MaNCC = ncc.MaNCC;
GO

--giảm tồn
UPDATE dbo.tbl_MatHang
SET SoLuongTon = 5
WHERE MaMH = 'MH001';

UPDATE dbo.tbl_MatHang
SET SoLuongTon = 12
WHERE MaMH = 'MH002';

UPDATE dbo.tbl_MatHang
SET SoLuongTon = 18
WHERE MaMH = 'MH003';
UPDATE dbo.tbl_MatHang
SET SoLuongTon = 10
WHERE MaMH = 'MH008';

---kiểm tra
SELECT MaMH, TenMH, SoLuongTon, TrangThaiTon
FROM dbo.vw_Kho_TonKho_HienTai
WHERE TrangThaiTon = N'Sắp hết';

--View lịch sử nhập hàng chi tiết - vw_Kho_LichSuNhapHang_ChiTiet
USE [WINMART];
GO

IF OBJECT_ID('dbo.vw_Kho_LichSuNhapHang_ChiTiet', 'V') IS NOT NULL
    DROP VIEW dbo.vw_Kho_LichSuNhapHang_ChiTiet;
GO

CREATE VIEW dbo.vw_Kho_LichSuNhapHang_ChiTiet
AS
SELECT
    pn.MaPN,
    pn.NgayNhap,
    pn.GhiChu,
    nv.MaNV,
    nv.HoTenNV          AS TenNhanVienNhap,
    ncc.MaNCC,
    ncc.TenNCC,
    mh.MaMH,
    mh.TenMH,
    ctpn.SoLuongNhap,
    ctpn.GiaNhap,
    ThanhTienNhap = ctpn.SoLuongNhap * ctpn.GiaNhap
FROM dbo.tbl_PhieuNhap      pn
JOIN dbo.tbl_CTPhieuNhap    ctpn ON pn.MaPN  = ctpn.MaPN
JOIN dbo.tbl_MatHang        mh   ON ctpn.MaMH = mh.MaMH
JOIN dbo.tbl_NhaCungCap     ncc  ON mh.MaNCC = ncc.MaNCC
JOIN dbo.tbl_NhanVien       nv   ON pn.MaNV  = nv.MaNV;
GO

--Bối cảnh: Thủ kho cần xem lại lịch sử nhập của một nhà cung cấp / một mặt hàng / một khoảng thời gian để,
--Đối chiếu hóa đơn nhà cung cấp, Phân tích giá nhập, số lượng nhập gần đây.
-- Xem tất cả lịch sử nhập
SELECT TOP 5 *
FROM dbo.vw_Kho_LichSuNhapHang_ChiTiet
ORDER BY NgayNhap DESC;

-- Xem các phiếu nhập trong tháng 3/2023
SELECT MaPN, NgayNhap, TenNCC, TenMH, SoLuongNhap, ThanhTienNhap
FROM dbo.vw_Kho_LichSuNhapHang_ChiTiet
WHERE NgayNhap BETWEEN '2023-03-01' AND '2023-03-31';

--View lịch sử xuất kho chi tiết - vw_Kho_LichSuXuatKho_ChiTiet
USE [WINMART];
GO

IF OBJECT_ID('dbo.vw_Kho_LichSuXuatKho_ChiTiet', 'V') IS NOT NULL
    DROP VIEW dbo.vw_Kho_LichSuXuatKho_ChiTiet;
GO

CREATE VIEW dbo.vw_Kho_LichSuXuatKho_ChiTiet
AS
SELECT
    px.MaPX,
    px.NgayXuat,
    px.GhiChu,
    nv.MaNV,
    nv.HoTenNV          AS TenNhanVienXuat,
    mh.MaMH,
    mh.TenMH,
    ctx.SoLuongXuat
FROM dbo.tbl_PhieuXuat      px
JOIN dbo.tbl_CTPhieuXuat    ctx ON px.MaPX  = ctx.MaPX
JOIN dbo.tbl_MatHang        mh  ON ctx.MaMH = mh.MaMH
JOIN dbo.tbl_NhanVien       nv  ON px.MaNV  = nv.MaNV;
GO

--Bối cảnh: Khi có chênh lệch tồn, thủ kho cần xem các lần xuất kho gần đây của một mặt hàng:
--Có bị xuất nhầm số lượng không?
--Người nào xuất? ngày nào?
-- Xem 5 phiếu xuất gần nhất
SELECT TOP 5 *
FROM dbo.vw_Kho_LichSuXuatKho_ChiTiet
ORDER BY NgayXuat DESC;
-- Xem lịch sử xuất kho của mặt hàng MH010
SELECT MaPX, NgayXuat, TenNhanVienXuat, TenMH, SoLuongXuat
FROM dbo.vw_Kho_LichSuXuatKho_ChiTiet
WHERE MaMH = 'MH010';

--View tổng hợp Nhập – Xuất – Bán – Tồn - vw_Kho_TongHopNhapXuatBan
USE [WINMART];
GO

IF OBJECT_ID('dbo.vw_Kho_TongHopNhapXuatBan', 'V') IS NOT NULL
    DROP VIEW dbo.vw_Kho_TongHopNhapXuatBan;
GO

CREATE VIEW dbo.vw_Kho_TongHopNhapXuatBan
AS
WITH Nhap AS
(
    SELECT MaMH, TongNhap = SUM(SoLuongNhap)
    FROM dbo.tbl_CTPhieuNhap
    GROUP BY MaMH
),
XuatKho AS
(
    SELECT MaMH, TongXuatKho = SUM(SoLuongXuat)
    FROM dbo.tbl_CTPhieuXuat
    GROUP BY MaMH
),
Ban AS
(
    SELECT MaMH, TongBan = SUM(SoLuongBan)
    FROM dbo.tbl_CTHoaDon
    GROUP BY MaMH
)
SELECT
    mh.MaMH,
    mh.TenMH,
    ISNULL(n.TongNhap,   0) AS TongNhap,
    ISNULL(x.TongXuatKho,0) AS TongXuatKho,
    ISNULL(b.TongBan,    0) AS TongBan,
    TonLyThuyet = ISNULL(n.TongNhap,0) - ISNULL(x.TongXuatKho,0) - ISNULL(b.TongBan,0),
    TonThucTe   = mh.SoLuongTon,
    LechTon     = mh.SoLuongTon - (ISNULL(n.TongNhap,0) - ISNULL(x.TongXuatKho,0) - ISNULL(b.TongBan,0))
FROM dbo.tbl_MatHang mh
LEFT JOIN Nhap   n ON mh.MaMH = n.MaMH
LEFT JOIN XuatKho x ON mh.MaMH = x.MaMH
LEFT JOIN Ban    b ON mh.MaMH = b.MaMH;
GO

--Bối cảnh:  Báo cáo định kỳ (tuần/tháng) để kho và kế toán kiểm tra:
--Hàng nào đang lệch tồn (LechTon ≠ 0)
--So sánh giữa: Số liệu theo chứng từ (Nhập/Xuất/Bán), Số lượng đang lưu tại bảng tồn kho.
-- Xem tổng hợp nhập – xuất – bán – tồn cho tất cả

SELECT *
FROM dbo.vw_Kho_TongHopNhapXuatBan;

-- Chỉ xem các mặt hàng đang bị lệch tồn
SELECT MaMH, TenMH, TongNhap, TongXuatKho, TongBan, TonLyThuyet, TonThucTe, LechTon
FROM dbo.vw_Kho_TongHopNhapXuatBan
WHERE LechTon <> 0;

--2.ỨNG DỤNG INDEX
--Index tra cứu phiếu nhập theo ngày - IDX_PhieuNhap_NgayNhap
CREATE NONCLUSTERED INDEX IDX_PhieuNhap_NgayNhap
ON dbo.tbl_PhieuNhap (NgayNhap)
INCLUDE (MaPN, MaNV, GhiChu);
GO

-- Lịch sử nhập hàng trong tháng 3/2023
SELECT MaPN, NgayNhap, GhiChu, MaNV
FROM dbo.tbl_PhieuNhap
WHERE NgayNhap BETWEEN '2023-03-01' AND '2023-03-31';

--Index chi tiết phiếu nhập theo mặt hàng
--Bối cảnh: Thủ kho hay phải trả lời câu hỏi: “Mặt hàng MH001 đã nhập những lúc nào, mỗi lần bao nhiêu, giá bao nhiêu?”
CREATE NONCLUSTERED INDEX IDX_CTPhieuNhap_MaMH_MaPN
ON dbo.tbl_CTPhieuNhap (MaMH, MaPN)
INCLUDE (SoLuongNhap, GiaNhap);
GO

-- Lịch sử nhập hàng của MH001
SELECT pn.MaPN, pn.NgayNhap, mh.TenMH,
       ctpn.SoLuongNhap, ctpn.GiaNhap
FROM dbo.tbl_PhieuNhap   pn
JOIN dbo.tbl_CTPhieuNhap ctpn ON pn.MaPN = ctpn.MaPN
JOIN dbo.tbl_MatHang     mh   ON ctpn.MaMH = mh.MaMH
WHERE ctpn.MaMH = 'MH001';

--Index tra cứu phiếu xuất kho theo ngày
--Bối cảnh:  Tương tự nhập, thủ kho cũng cần: Xem các phiếu xuất trong một khoảng ngày để đối chiếu.
CREATE NONCLUSTERED INDEX IDX_PhieuXuat_NgayXuat
ON dbo.tbl_PhieuXuat (NgayXuat)
INCLUDE (MaPX, MaNV, GhiChu);
GO

-- Xem các phiếu xuất trong tháng 5/2024
SELECT MaPX, NgayXuat, GhiChu, MaNV
FROM dbo.tbl_PhieuXuat
WHERE NgayXuat BETWEEN '2024-05-01' AND '2024-05-31';

--Index chi tiết hóa đơn theo mặt hàng (đối chiếu lượng bán)
--Bối cảnh: View vw_Kho_TongHopNhapXuatBan và các báo cáo kho cần biết: Từng mặt hàng đã bán ra tổng cộng bao nhiêu:
CREATE NONCLUSTERED INDEX IDX_CTHoaDon_MaMH
ON dbo.tbl_CTHoaDon (MaMH)
INCLUDE (SoLuongBan, GiaBan, MaHD);
GO

-- Tổng số lượng đã bán theo từng mặt hàng

SELECT MaMH, SUM(SoLuongBan) AS TongSoLuongBan
FROM dbo.tbl_CTHoaDon
GROUP BY MaMH;

--Index chi tiết kiểm kê theo mặt hàng
--Bối cảnh:  Trong view vw_Kho_BaoCaoKiemKe_LechTon, hoặc khi phân tích lệch tồn, thường cần:
--Xem tất cả phiếu kiểm kê liên quan đến một mặt hàng:
CREATE NONCLUSTERED INDEX IDX_CTPhieuKiemKe_MaMH_MaPKK
ON dbo.tbl_CTPhieuKiemKe (MaMH, MaPKK)
INCLUDE (SoLuongNhap, SoLuongXuat, SoLuongBan,
         SoLuongTonQuay, SoLuongTonKho);
GO

-- Các lần kiểm kê liên quan tới MH001
SELECT pkk.MaPKK, pkk.NgayKK, mh.TenMH,
       ctk.SoLuongTonQuay, ctk.SoLuongTonKho
FROM dbo.tbl_PhieuKiemKe      pkk
JOIN dbo.tbl_CTPhieuKiemKe    ctk ON pkk.MaPKK = ctk.MaPKK
JOIN dbo.tbl_MatHang          mh  ON ctk.MaMH  = mh.MaMH
WHERE ctk.MaMH = 'MH001';

--Index cho lịch sử nhập theo Mặt hàng + Ngày
--Để tối ưu: Dùng index gộp (composite): (MaMH, MaPN)
--INCLUDE luôn SoLuongNhap, GiaNhap để truy vấn được “covering” (không cần quay lại bảng gốc).
CREATE NONCLUSTERED INDEX IDX_CTPhieuNhap_MaMH_MaPN_Covering
ON dbo.tbl_CTPhieuNhap (MaMH, MaPN)
INCLUDE (SoLuongNhap, GiaNhap);
GO

-- Lịch sử nhập cho MH001 (sử dụng index composit)
SELECT pn.NgayNhap, pn.MaPN, mh.TenMH,
       ctpn.SoLuongNhap, ctpn.GiaNhap
FROM dbo.tbl_CTPhieuNhap ctpn
JOIN dbo.tbl_PhieuNhap   pn ON ctpn.MaPN = pn.MaPN
JOIN dbo.tbl_MatHang     mh ON ctpn.MaMH = mh.MaMH
WHERE ctpn.MaMH = 'MH001'
ORDER BY pn.NgayNhap;

--3.ỨNG DỤNG PRODUCE 
--Kiểu bảng Chi tiết nhập
USE [WINMART];
GO

IF TYPE_ID('dbo.NhapHangChiTietType') IS NOT NULL
    DROP TYPE dbo.NhapHangChiTietType;
GO

CREATE TYPE dbo.NhapHangChiTietType AS TABLE
(
    MaMH        VARCHAR(10) NOT NULL,
    SoLuongNhap INT         NOT NULL,
    GiaNhap     INT         NOT NULL
);
GO
--Kiểu bảng chi tiết xuất
IF TYPE_ID('dbo.XuatKhoChiTietType') IS NOT NULL
    DROP TYPE dbo.XuatKhoChiTietType;
GO

CREATE TYPE dbo.XuatKhoChiTietType AS TABLE
(
    MaMH        VARCHAR(10) NOT NULL,
    SoLuongXuat INT         NOT NULL
);
GO
--usp_ThuKho_TaoPhieuNhapHang – Tạo phiếu nhập + chi tiết
--Bối cảnh: Nhân viên thủ kho: Nhập hàng từ nhà cung cấp,Cần tạo Phiếu nhập (tbl_PhieuNhap) + Chi tiết (tbl_CTPhieuNhap) 
--trong 1 thao tác
--Đảm bảo: Mã phiếu không trùng, Mã mặt hàng tồn tại, Số lượng, giá nhập > 0
USE [WINMART];
GO

IF OBJECT_ID('dbo.usp_ThuKho_TaoPhieuNhapHang', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_ThuKho_TaoPhieuNhapHang;
GO

CREATE PROCEDURE dbo.usp_ThuKho_TaoPhieuNhapHang
(
    @MaPN      VARCHAR(10),
    @NgayNhap  DATE,
    @GhiChu    NVARCHAR(200) = NULL,
    @MaNV      VARCHAR(10),
    @ChiTiet   dbo.NhapHangChiTietType READONLY
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRAN;

        -- 1. Kiểm tra mã phiếu nhập trùng
        IF EXISTS (SELECT 1 FROM dbo.tbl_PhieuNhap WHERE MaPN = @MaPN)
        BEGIN
            RAISERROR (N'Mã phiếu nhập %s đã tồn tại.', 16, 1, @MaPN);
            ROLLBACK TRAN;
            RETURN;
        END

        -- 2. Kiểm tra chi tiết có rỗng không
        IF NOT EXISTS (SELECT 1 FROM @ChiTiet)
        BEGIN
            RAISERROR (N'Phiếu nhập phải có ít nhất 1 dòng chi tiết.', 16, 1);
            ROLLBACK TRAN;
            RETURN;
        END

        -- 3. Kiểm tra mã mặt hàng hợp lệ
        IF EXISTS (
            SELECT 1
            FROM @ChiTiet c
            LEFT JOIN dbo.tbl_MatHang mh ON c.MaMH = mh.MaMH
            WHERE mh.MaMH IS NULL
        )
        BEGIN
            RAISERROR (N'Có mã mặt hàng không tồn tại trong danh mục.', 16, 1);
            ROLLBACK TRAN;
            RETURN;
        END

        -- 4. Kiểm tra số lượng, giá nhập > 0
        IF EXISTS (
            SELECT 1
            FROM @ChiTiet
            WHERE SoLuongNhap <= 0 OR GiaNhap <= 0
        )
        BEGIN
            RAISERROR (N'Số lượng nhập và giá nhập phải lớn hơn 0.', 16, 1);
            ROLLBACK TRAN;
            RETURN;
        END

        -- 5. Thêm phiếu nhập
        INSERT INTO dbo.tbl_PhieuNhap (MaPN, NgayNhap, GhiChu, MaNV)
        VALUES (@MaPN, @NgayNhap, @GhiChu, @MaNV);

        -- 6. Thêm chi tiết phiếu nhập
        INSERT INTO dbo.tbl_CTPhieuNhap (MaPN, MaMH, SoLuongNhap, GiaNhap)
        SELECT @MaPN, MaMH, SoLuongNhap, GiaNhap
        FROM @ChiTiet;

        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRAN;

        DECLARE @ErrMsg NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrMsg, 16, 1);
    END CATCH
END;
GO

--Giả sử thủ kho NV007 nhập thêm hàng:
--Phiếu nhập mới: PN021
--Ngày nhập: 2023-09-01
--Nhập: 50 hộp MH001 – giá 25.600, 30 lon MH005 – giá 7.200
DECLARE @CT dbo.NhapHangChiTietType;

INSERT INTO @CT (MaMH, SoLuongNhap, GiaNhap)
VALUES 
    ('MH001', 50, 25600),
    ('MH005', 30, 7200);

EXEC dbo.usp_ThuKho_TaoPhieuNhapHang
    @MaPN     = 'PN028',
    @NgayNhap = '2023-09-01',
    @GhiChu   = N'Nhập bổ sung hàng sữa & nước ngọt',
    @MaNV     = 'NV007',     -- nhân viên thủ kho
    @ChiTiet  = @CT;

--Kiểm tra
SELECT * FROM dbo.tbl_PhieuNhap WHERE MaPN = 'PN028';
SELECT * FROM dbo.tbl_CTPhieuNhap WHERE MaPN = 'PN028';

--usp_ThuKho_TaoPhieuXuatKho – Xuất kho có kiểm tra tồn
--Kho xuất hàng: Xuất từ kho tổng → quầy bán lẻ, hoặc điều chuyển
--Phải không được xuất vượt quá tồn hiện tại, Procedure này: Nhận @MaPX, @NgayXuat, @MaNV, @GhiChu + TVP chi tiết
-- Với mỗi mặt hàng: Kiểm tra SoLuongTon >= SoLuongXuat,Nếu thiếu → báo lỗi, rollback
USE [WINMART];
GO

IF OBJECT_ID('dbo.usp_ThuKho_TaoPhieuXuatKho', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_ThuKho_TaoPhieuXuatKho;
GO

CREATE PROCEDURE dbo.usp_ThuKho_TaoPhieuXuatKho
(
    @MaPX      VARCHAR(10),
    @NgayXuat  DATE,
    @GhiChu    NVARCHAR(200) = NULL,
    @MaNV      VARCHAR(10),
    @ChiTiet   dbo.XuatKhoChiTietType READONLY
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRAN;

        -- 1. Kiểm tra mã phiếu xuất trùng
        IF EXISTS (SELECT 1 FROM dbo.tbl_PhieuXuat WHERE MaPX = @MaPX)
        BEGIN
            RAISERROR (N'Mã phiếu xuất %s đã tồn tại.', 16, 1, @MaPX);
            ROLLBACK TRAN;
            RETURN;
        END

        -- 2. Chi tiết không được rỗng
        IF NOT EXISTS (SELECT 1 FROM @ChiTiet)
        BEGIN
            RAISERROR (N'Phiếu xuất phải có ít nhất 1 dòng chi tiết.', 16, 1);
            ROLLBACK TRAN;
            RETURN;
        END

        -- 3. Kiểm tra mã mặt hàng
        IF EXISTS (
            SELECT 1
            FROM @ChiTiet c
            LEFT JOIN dbo.tbl_MatHang mh ON c.MaMH = mh.MaMH
            WHERE mh.MaMH IS NULL
        )
        BEGIN
            RAISERROR (N'Có mã mặt hàng trong phiếu xuất không tồn tại.', 16, 1);
            ROLLBACK TRAN;
            RETURN;
        END

        -- 4. Kiểm tra số lượng xuất > 0
        IF EXISTS (
            SELECT 1
            FROM @ChiTiet
            WHERE SoLuongXuat <= 0
        )
        BEGIN
            RAISERROR (N'Số lượng xuất phải lớn hơn 0.', 16, 1);
            ROLLBACK TRAN;
            RETURN;
        END

        -- 5. Kiểm tra không xuất vượt tồn
        IF EXISTS (
            SELECT 1
            FROM @ChiTiet c
            JOIN dbo.tbl_MatHang mh ON c.MaMH = mh.MaMH
            WHERE c.SoLuongXuat > mh.SoLuongTon
        )
        BEGIN
            RAISERROR (N'Số lượng xuất vượt quá tồn kho hiện tại.', 16, 1);
            ROLLBACK TRAN;
            RETURN;
        END

        -- 6. Thêm phiếu xuất
        INSERT INTO dbo.tbl_PhieuXuat (MaPX, NgayXuat, GhiChu, MaNV)
        VALUES (@MaPX, @NgayXuat, @GhiChu, @MaNV);

        -- 7. Thêm chi tiết phiếu xuất
        INSERT INTO dbo.tbl_CTPhieuXuat (MaPX, MaMH, SoLuongXuat)
        SELECT @MaPX, MaMH, SoLuongXuat
        FROM @ChiTiet;

        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRAN;

        DECLARE @ErrMsg NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrMsg, 16, 1);
    END CATCH
END;
GO

--Ví dụ áp dụng: Giả sử:
--Mặt hàng MH001 hiện có SoLuongTon = 55
--Kho muốn xuất 10 hộp ra quầy:
DECLARE @CTX dbo.XuatKhoChiTietType;

INSERT INTO @CTX (MaMH, SoLuongXuat)
VALUES ('MH001', 100);

EXEC dbo.usp_ThuKho_TaoPhieuXuatKho
    @MaPX     = 'PX022',
    @NgayXuat = '2024-09-01',
    @GhiChu   = N'Xuất hàng ra quầy bán lẻ',
    @MaNV     = 'NV008',   -- thủ kho
    @ChiTiet  = @CTX;
--Nếu SoLuongXuat = 10 ≤ tồn → phiếu xuất + chi tiết được tạo thành công
--Nếu thử SoLuongXuat = 999 → procedure sẽ báo: Số lượng xuất vượt quá tồn kho hiện tại và ROLLBACK, không tạo phiếu.
UPDATE dbo.tbl_MatHang
SET SoLuongTon = 55
WHERE MaMH = 'MH001';

--usp_ThuKho_LapPhieuKiemKeTuDong – Lập phiếu kiểm kê tự động
USE [WINMART];
GO

IF OBJECT_ID('dbo.usp_ThuKho_LapPhieuKiemKeTuDong', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_ThuKho_LapPhieuKiemKeTuDong;
GO

CREATE PROCEDURE dbo.usp_ThuKho_LapPhieuKiemKeTuDong
(
    @MaPKK    VARCHAR(15),
    @NgayKK   DATE,
    @GhiChu   NVARCHAR(200) = NULL,
    @MaNV     VARCHAR(10)     -- nhân viên lập phiếu kiểm kê
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRAN;

        -- 1. Kiểm tra mã phiếu kiểm kê
        IF EXISTS (SELECT 1 FROM dbo.tbl_PhieuKiemKe WHERE MaPKK = @MaPKK)
        BEGIN
            RAISERROR (N'Mã phiếu kiểm kê %s đã tồn tại.', 16, 1, @MaPKK);
            ROLLBACK TRAN;
            RETURN;
        END

        -- 2. Thêm phiếu kiểm kê
        INSERT INTO dbo.tbl_PhieuKiemKe (MaPKK, NgayKK, GhiChu, MaNV)
        VALUES (@MaPKK, @NgayKK, @GhiChu, @MaNV);

        /*
            3. Tính toán dữ liệu kiểm kê từ hệ thống:
               - SoLuongNhap   : tổng SoLuongNhap trong CTPhieuNhap
               - SoLuongXuat   : tổng SoLuongXuat trong CTPhieuXuat
               - SoLuongBan    : tổng SoLuongBan trong CTHoaDon
               - SoLuongTonKho : lấy từ tbl_MatHang.SoLuongTon (tồn trong kho)
               - SoLuongTonQuay: Tồn hệ thống - Tồn kho
                                  với Tồn hệ thống = Nhập - Xuất - Bán
        */

        ;WITH Nhap AS
        (
            SELECT MaMH, SoLuongNhap = SUM(SoLuongNhap)
            FROM dbo.tbl_CTPhieuNhap
            GROUP BY MaMH
        ),
        Xuat AS
        (
            SELECT MaMH, SoLuongXuat = SUM(SoLuongXuat)
            FROM dbo.tbl_CTPhieuXuat
            GROUP BY MaMH
        ),
        Ban AS
        (
            SELECT MaMH, SoLuongBan = SUM(SoLuongBan)
            FROM dbo.tbl_CTHoaDon
            GROUP BY MaMH
        )
        INSERT INTO dbo.tbl_CTPhieuKiemKe
        (
            MaPKK, MaMH, SoLuongNhap, SoLuongXuat, SoLuongBan,
            SoLuongTonQuay, SoLuongTonKho
        )
        SELECT
            @MaPKK                          AS MaPKK,
            mh.MaMH,
            ISNULL(n.SoLuongNhap, 0)        AS SoLuongNhap,
            ISNULL(x.SoLuongXuat, 0)        AS SoLuongXuat,
            ISNULL(b.SoLuongBan,  0)        AS SoLuongBan,
            -- Tồn quầy = MAX( Tồn hệ thống - Tồn kho, 0 )
            CASE 
                WHEN (ISNULL(n.SoLuongNhap,0) 
                      - ISNULL(x.SoLuongXuat,0) 
                      - ISNULL(b.SoLuongBan,0) 
                      - mh.SoLuongTon) < 0
                    THEN 0
                ELSE (ISNULL(n.SoLuongNhap,0) 
                      - ISNULL(x.SoLuongXuat,0) 
                      - ISNULL(b.SoLuongBan,0) 
                      - mh.SoLuongTon)
            END                             AS SoLuongTonQuay,
            mh.SoLuongTon                   AS SoLuongTonKho
        FROM dbo.tbl_MatHang mh
        LEFT JOIN Nhap n ON mh.MaMH = n.MaMH
        LEFT JOIN Xuat x ON mh.MaMH = x.MaMH
        LEFT JOIN Ban  b ON mh.MaMH = b.MaMH;

        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRAN;

        DECLARE @ErrMsg NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrMsg, 16, 1);
    END CATCH
END;
GO
--Ví dụ áp dụng
EXEC dbo.usp_ThuKho_LapPhieuKiemKeTuDong
    @MaPKK  = 'PKK030',
    @NgayKK = '2024-10-01',
    @GhiChu = N'Kiểm kê tồn quầy',
    @MaNV   = 'NV019';

SELECT * FROM dbo.tbl_PhieuKiemKe WHERE MaPKK = 'PKK030';

SELECT *
FROM dbo.tbl_CTPhieuKiemKe
WHERE MaPKK = 'PKK030';

--usp_ThuKho_TraCuuNhapXuatBan_TheoMatHang – Báo cáo tổng hợp theo 1 mặt hàng
USE [WINMART];
GO

IF OBJECT_ID('dbo.usp_ThuKho_TraCuuNhapXuatBan_TheoMatHang', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_ThuKho_TraCuuNhapXuatBan_TheoMatHang;
GO

CREATE PROCEDURE dbo.usp_ThuKho_TraCuuNhapXuatBan_TheoMatHang
(
    @MaMH VARCHAR(10)
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        mh.MaMH,
        mh.TenMH,
        TongNhap = ISNULL(n.TongNhap,   0),
        TongXuat = ISNULL(x.TongXuat,   0),
        TongBan  = ISNULL(b.TongBan,    0),
        TonLyThuyet = ISNULL(n.TongNhap,0) - ISNULL(x.TongXuat,0) - ISNULL(b.TongBan,0),
        TonThucTe   = mh.SoLuongTon,
        LechTon     = mh.SoLuongTon - (ISNULL(n.TongNhap,0) - ISNULL(x.TongXuat,0) - ISNULL(b.TongBan,0))
    FROM dbo.tbl_MatHang mh
    LEFT JOIN
    (
        SELECT MaMH, SUM(SoLuongNhap) AS TongNhap
        FROM dbo.tbl_CTPhieuNhap
        GROUP BY MaMH
    ) n ON mh.MaMH = n.MaMH
    LEFT JOIN
    (
        SELECT MaMH, SUM(SoLuongXuat) AS TongXuat
        FROM dbo.tbl_CTPhieuXuat
        GROUP BY MaMH
    ) x ON mh.MaMH = x.MaMH
    LEFT JOIN
    (
        SELECT MaMH, SUM(SoLuongBan) AS TongBan
        FROM dbo.tbl_CTHoaDon
        GROUP BY MaMH
    ) b ON mh.MaMH = b.MaMH
    WHERE mh.MaMH = @MaMH;
END;
GO
--Ví dụ
EXEC dbo.usp_ThuKho_TraCuuNhapXuatBan_TheoMatHang
     @MaMH = 'MH015';

--usp_ThuKho_BaoCaoNhapXuatTon_TheoKhoangNgay: Báo cáo Nhập – Xuất – Bán – Tồn theo khoảng ngày
--Với mỗi mặt hàng: Tồn đầu kỳ = Nhập trước kỳ – Xuất trước kỳ – Bán trước kỳ
--Nhập trong kỳ = tổng nhập từ @TuNgay → @DenNgay
--Xuất trong kỳ = tổng xuất từ @TuNgay → @DenNgay
--Bán trong kỳ = tổng bán từ @TuNgay → @DenNgay
--Tồn cuối kỳ = Tồn đầu kỳ + Nhập kỳ – Xuất kỳ – Bán kỳ
--=> Proc này để thủ kho in báo cáo tổng hợp.
USE [WINMART];
GO

IF OBJECT_ID('dbo.usp_ThuKho_BaoCaoNhapXuatTon_TheoKhoangNgay', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_ThuKho_BaoCaoNhapXuatTon_TheoKhoangNgay;
GO

CREATE PROCEDURE dbo.usp_ThuKho_BaoCaoNhapXuatTon_TheoKhoangNgay
(
    @TuNgay  DATE,
    @DenNgay DATE
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Nhập trước kỳ
    ;WITH NhapTruoc AS
    (
        SELECT ctn.MaMH, SUM(ctn.SoLuongNhap) AS TongNhapTruoc
        FROM dbo.tbl_CTPhieuNhap ctn
        JOIN dbo.tbl_PhieuNhap pn ON ctn.MaPN = pn.MaPN
        WHERE pn.NgayNhap < @TuNgay
        GROUP BY ctn.MaMH
    ),
    XuatTruoc AS
    (
        SELECT ctx.MaMH, SUM(ctx.SoLuongXuat) AS TongXuatTruoc
        FROM dbo.tbl_CTPhieuXuat ctx
        JOIN dbo.tbl_PhieuXuat px ON ctx.MaPX = px.MaPX
        WHERE px.NgayXuat < @TuNgay
        GROUP BY ctx.MaMH
    ),
    BanTruoc AS
    (
        SELECT cthd.MaMH, SUM(cthd.SoLuongBan) AS TongBanTruoc
        FROM dbo.tbl_CTHoaDon cthd
        JOIN dbo.tbl_HoaDon hd ON cthd.MaHD = hd.MaHD
        WHERE hd.NgayBan < @TuNgay
        GROUP BY cthd.MaMH
    ),
    NhapTrongKy AS
    (
        SELECT ctn.MaMH, SUM(ctn.SoLuongNhap) AS TongNhapTrongKy
        FROM dbo.tbl_CTPhieuNhap ctn
        JOIN dbo.tbl_PhieuNhap pn ON ctn.MaPN = pn.MaPN
        WHERE pn.NgayNhap BETWEEN @TuNgay AND @DenNgay
        GROUP BY ctn.MaMH
    ),
    XuatTrongKy AS
    (
        SELECT ctx.MaMH, SUM(ctx.SoLuongXuat) AS TongXuatTrongKy
        FROM dbo.tbl_CTPhieuXuat ctx
        JOIN dbo.tbl_PhieuXuat px ON ctx.MaPX = px.MaPX
        WHERE px.NgayXuat BETWEEN @TuNgay AND @DenNgay
        GROUP BY ctx.MaMH
    ),
    BanTrongKy AS
    (
        SELECT cthd.MaMH, SUM(cthd.SoLuongBan) AS TongBanTrongKy
        FROM dbo.tbl_CTHoaDon cthd
        JOIN dbo.tbl_HoaDon hd ON cthd.MaHD = hd.MaHD
        WHERE hd.NgayBan BETWEEN @TuNgay AND @DenNgay
        GROUP BY cthd.MaMH
    )
    SELECT 
        mh.MaMH,
        mh.TenMH,
        TonDauKy = ISNULL(nt.TongNhapTruoc,0) 
                   - ISNULL(xt.TongXuatTruoc,0) 
                   - ISNULL(bt.TongBanTruoc,0),
        TongNhapTrongKy = ISNULL(nk.TongNhapTrongKy,0),
        TongXuatTrongKy = ISNULL(xk.TongXuatTrongKy,0),
        TongBanTrongKy  = ISNULL(bk.TongBanTrongKy,0),
        TonCuoiKy = (ISNULL(nt.TongNhapTruoc,0) 
                     - ISNULL(xt.TongXuatTruoc,0) 
                     - ISNULL(bt.TongBanTruoc,0))
                    + ISNULL(nk.TongNhapTrongKy,0)
                    - ISNULL(xk.TongXuatTrongKy,0)
                    - ISNULL(bk.TongBanTrongKy,0)
    FROM dbo.tbl_MatHang mh
    LEFT JOIN NhapTruoc   nt ON mh.MaMH = nt.MaMH
    LEFT JOIN XuatTruoc   xt ON mh.MaMH = xt.MaMH
    LEFT JOIN BanTruoc    bt ON mh.MaMH = bt.MaMH
    LEFT JOIN NhapTrongKy nk ON mh.MaMH = nk.MaMH
    LEFT JOIN XuatTrongKy xk ON mh.MaMH = xk.MaMH
    LEFT JOIN BanTrongKy  bk ON mh.MaMH = bk.MaMH;
END;
GO

--Ví dụ áp dụng
EXEC dbo.usp_ThuKho_BaoCaoNhapXuatTon_TheoKhoangNgay
    @TuNgay  = '2024-01-01',
    @DenNgay = '2025-03-31';

--usp_ThuKho_DanhSachMatHangCanNhapThem - Danh sách mặt hàng cần nhập thêm, theo ngưỡng tồn kho do kho nhập vào.
--Thủ kho muốn biết: mặt hàng nào tồn < ngưỡng an toàn,
--Proc nhận tham số @NguongTon → trả về các mặt hàng cần nhập thêm.
USE [WINMART];
GO

IF OBJECT_ID('dbo.usp_ThuKho_DanhSachMatHangCanNhapThem', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_ThuKho_DanhSachMatHangCanNhapThem;
GO

CREATE PROCEDURE dbo.usp_ThuKho_DanhSachMatHangCanNhapThem
(
    @NguongTon INT -- giả sủ 30
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        mh.MaMH,
        mh.TenMH,
        lh.TenLH          AS TenLoaiHang,
        mh.SoLuongTon,
        TrangThai = CASE 
                        WHEN mh.SoLuongTon <= 0 THEN N'Hết hàng'
                        WHEN mh.SoLuongTon < @NguongTon THEN N'Cần nhập thêm'
                        ELSE N'Đủ tồn'
                    END
    FROM dbo.tbl_MatHang mh
    JOIN dbo.tbl_LoaiHang lh ON mh.MaLH = lh.MaLH
    WHERE mh.SoLuongTon < @NguongTon
    ORDER BY mh.SoLuongTon ASC;
END;
GO
--Ví dụ
-- Thủ kho muốn xem những mặt hàng tồn dưới 40
EXEC dbo.usp_ThuKho_DanhSachMatHangCanNhapThem
    @NguongTon = 40;

--4.ỨNG DỤNG TRIGGER
--TRG_CTPhieuNhap_UpdateTonKho: Tự động cộng tồn kho khi thêm / sửa chi tiết phiếu nhập
USE [WINMART];
GO

IF OBJECT_ID('dbo.TRG_CTPhieuNhap_UpdateTonKho', 'TR') IS NOT NULL
    DROP TRIGGER dbo.TRG_CTPhieuNhap_UpdateTonKho;
GO

CREATE TRIGGER dbo.TRG_CTPhieuNhap_UpdateTonKho
ON dbo.tbl_CTPhieuNhap
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    ;WITH Delta AS
    (
        SELECT 
            COALESCE(i.MaMH, d.MaMH) AS MaMH,
            SUM(ISNULL(i.SoLuongNhap,0) - ISNULL(d.SoLuongNhap,0)) AS DeltaNhap
        FROM inserted i
        FULL JOIN deleted  d
             ON i.MaPN = d.MaPN AND i.MaMH = d.MaMH
        GROUP BY COALESCE(i.MaMH, d.MaMH)
    )
    UPDATE mh
        SET mh.SoLuongTon = mh.SoLuongTon + d.DeltaNhap
    FROM dbo.tbl_MatHang mh
    JOIN Delta d ON mh.MaMH = d.MaMH;
END;
GO

--Kho nhập thêm hàng:
-- Trước khi nhập
SELECT MaMH, SoLuongTon FROM dbo.tbl_MatHang WHERE MaMH = 'MH001';

-- Tạo phiếu nhập mới PN030, nhập thêm 10 hộp MH001
INSERT INTO dbo.tbl_PhieuNhap (MaPN, NgayNhap, GhiChu, MaNV)
VALUES ('PN030', '2023-09-20', N'Phiếu nhập hàng số 30', 'NV007');

INSERT INTO dbo.tbl_CTPhieuNhap (MaPN, MaMH, SoLuongNhap, GiaNhap)
VALUES ('PN030', 'MH001', 10, 26000);   -- TRIGGER chạy

-- Kiểm tra lại tồn
SELECT MaMH, SoLuongTon FROM dbo.tbl_MatHang WHERE MaMH = 'MH001';

--TRG_CTPhieuXuat_CheckVaUpdateTonKho: Kiểm tra không xuất vượt tồn + trừ tồn kho khi xuất
USE [WINMART];
GO

IF OBJECT_ID('dbo.TRG_CTPhieuXuat_CheckVaUpdateTonKho', 'TR') IS NOT NULL
    DROP TRIGGER dbo.TRG_CTPhieuXuat_CheckVaUpdateTonKho;
GO

CREATE TRIGGER dbo.TRG_CTPhieuXuat_CheckVaUpdateTonKho
ON dbo.tbl_CTPhieuXuat
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- Lưu phần chênh lệch tồn kho vào bảng tạm
    DECLARE @Delta TABLE
    (
        MaMH     VARCHAR(10) PRIMARY KEY,
        DeltaTon INT
    );

    INSERT INTO @Delta (MaMH, DeltaTon)
    SELECT 
        COALESCE(i.MaMH, d.MaMH) AS MaMH,
        SUM(
              ISNULL(d.SoLuongXuat,0)   
            - ISNULL(i.SoLuongXuat,0)   
        ) AS DeltaTon
    FROM inserted i
    FULL JOIN deleted  d
         ON i.MaPX = d.MaPX AND i.MaMH = d.MaMH
    GROUP BY COALESCE(i.MaMH, d.MaMH);

    -- 1. Kiểm tra không âm tồn kho
    IF EXISTS
    (
        SELECT 1
        FROM @Delta dt
        JOIN dbo.tbl_MatHang mh ON dt.MaMH = mh.MaMH
        WHERE mh.SoLuongTon + dt.DeltaTon < 0
    )
    BEGIN
        RAISERROR (N'Số lượng xuất kho vượt quá tồn kho hiện tại.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- 2. Cập nhật tồn kho
    UPDATE mh
        SET mh.SoLuongTon = mh.SoLuongTon + dt.DeltaTon
    FROM dbo.tbl_MatHang mh
    JOIN @Delta dt ON mh.MaMH = dt.MaMH;
END;
GO
-- Xem tồn MH001 hiện tại
SELECT MaMH, SoLuongTon FROM dbo.tbl_MatHang WHERE MaMH = 'MH001';

-- Thử xuất 5 hộp MH001 (nếu tồn đủ)
INSERT INTO dbo.tbl_PhieuXuat (MaPX, NgayXuat, GhiChu, MaNV)
VALUES ('PX030', '2024-09-20', N'Xuất test trigger', 'NV008');

INSERT INTO dbo.tbl_CTPhieuXuat (MaPX, MaMH, SoLuongXuat)
VALUES ('PX030', 'MH001', 5);  -- TRIGGER kiểm tra + trừ tồn

SELECT MaMH, SoLuongTon FROM dbo.tbl_MatHang WHERE MaMH = 'MH001';

-- Thử xuất 5 hộp MH001 (nếu tồn đủ)
INSERT INTO dbo.tbl_PhieuXuat (MaPX, NgayXuat, GhiChu, MaNV)
VALUES ('PX033', '2024-09-20', N'Xuất test trigger', 'NV008');

INSERT INTO dbo.tbl_CTPhieuXuat (MaPX, MaMH, SoLuongXuat)
VALUES ('PX033', 'MH001', 100);  -- TRIGGER kiểm tra + trừ tồn

--TRG_CTPhieuNhap_BlockDelete: Không cho xóa chi tiết phiếu nhập để bảo vệ lịch sử kho
IF OBJECT_ID('dbo.TRG_CTPhieuNhap_BlockDelete', 'TR') IS NOT NULL
    DROP TRIGGER dbo.TRG_CTPhieuNhap_BlockDelete;
GO

CREATE TRIGGER dbo.TRG_CTPhieuNhap_BlockDelete
ON dbo.tbl_CTPhieuNhap
INSTEAD OF DELETE
AS
BEGIN
    RAISERROR(
        N'Không được xóa chi tiết phiếu nhập. Vui lòng lập chứng từ điều chỉnh hoặc phiếu xuất trả nhà cung cấp.',
        16, 1
    );
END;
GO

--Bối cảnh + ví dụ: Nhân viên thủ kho lỡ tay
DELETE FROM dbo.tbl_CTPhieuNhap
WHERE MaPN = 'PN001' AND MaMH = 'MH001';

--TRG_CTPhieuKiemKe_DieuChinhTonKho: Điều chỉnh tồn kho theo kết quả kiểm kê
--Ý tưởng:Sau khi kiểm kê, bạn chỉnh sửa SoLuongTonKho trong tbl_CTPhieuKiemKe (ghi lại tồn kho thực tế).
--Trigger sẽ: Lấy SoLuongTonKho mới
--Cập nhật tbl_MatHang.SoLuongTon = SoLuongTonKho tương ứng.
IF OBJECT_ID('dbo.TRG_CTPhieuKiemKe_DieuChinhTonKho', 'TR') IS NOT NULL
    DROP TRIGGER dbo.TRG_CTPhieuKiemKe_DieuChinhTonKho;
GO

CREATE TRIGGER dbo.TRG_CTPhieuKiemKe_DieuChinhTonKho
ON dbo.tbl_CTPhieuKiemKe
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Chỉ xử lý khi SoLuongTonKho thay đổi
    IF NOT UPDATE(SoLuongTonKho)
        RETURN;

    UPDATE mh
        SET mh.SoLuongTon = i.SoLuongTonKho
    FROM inserted i
    JOIN dbo.tbl_MatHang mh ON i.MaMH = mh.MaMH;
END;
GO
--Kho kiểm kê lại MH001, thấy thực tế chỉ còn 48:
UPDATE dbo.tbl_CTPhieuKiemKe
SET SoLuongTonKho = 48
WHERE MaPKK = 'PKK021' AND MaMH = 'MH001';  -- TRIGGER chạy

--Kiểm tra tồn kho thực tê
SELECT MaMH, SoLuongTon
FROM dbo.tbl_MatHang
WHERE MaMH = 'MH001';
--SoLuongTon của MH001 sẽ được cập nhật thành 48 →
--Toàn bộ view vw_Kho_TonKho_HienTai và các proc báo cáo kho sẽ dùng số liệu sau kiểm kê.

--TRG_MatHang_LogThayDoiTonKho: Ghi log mọi lần thay đổi tồn kho
--B1: Tạo bảng log
IF OBJECT_ID('dbo.tbl_LogTonKho', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.tbl_LogTonKho
    (
        LogID         INT IDENTITY(1,1) PRIMARY KEY,
        ThoiGian      DATETIME      NOT NULL DEFAULT GETDATE(),
        MaMH          VARCHAR(10)   NOT NULL,
        SoLuongTon_Cu INT           NULL,
        SoLuongTon_Moi INT          NULL,
        GhiChu        NVARCHAR(200) NULL
    );
END
GO

--B2: Trigger log
IF OBJECT_ID('dbo.TRG_MatHang_LogThayDoiTonKho', 'TR') IS NOT NULL
    DROP TRIGGER dbo.TRG_MatHang_LogThayDoiTonKho;
GO

CREATE TRIGGER dbo.TRG_MatHang_LogThayDoiTonKho
ON dbo.tbl_MatHang
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Chỉ log khi SoLuongTon thay đổi
    IF NOT UPDATE(SoLuongTon)
        RETURN;

    INSERT INTO dbo.tbl_LogTonKho (MaMH, SoLuongTon_Cu, SoLuongTon_Moi, GhiChu)
    SELECT 
        d.MaMH,
        d.SoLuongTon,
        i.SoLuongTon,
        N'Thay đổi tồn kho do nhập/xuất/kiểm kê'
    FROM deleted d
    JOIN inserted i ON d.MaMH = i.MaMH
    WHERE d.SoLuongTon <> i.SoLuongTon;
END;
GO

-- Xem tồn trước
SELECT MaMH, SoLuongTon 
FROM dbo.tbl_MatHang
WHERE MaMH = 'MH007';
-- Cập nhật tồn thử 1 đơn vị
UPDATE dbo.tbl_MatHang
SET SoLuongTon = SoLuongTon + 2
WHERE MaMH = 'MH007';   

-- Xem log
SELECT *
FROM dbo.tbl_LogTonKho
ORDER BY LogID DESC;

--Trigger log chứng từ kho (Phiếu nhập / Phiếu xuất): Ghi lại lịch sử thao tác trên phiếu nhập – phiếu xuất
-- → Nâng cao khả năng audit: ai tạo / sửa / xóa chứng từ kho.
--Bảng log chung cho chứng từ kho
USE [WINMART];
GO

IF OBJECT_ID('dbo.tbl_LogChungTuKho', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.tbl_LogChungTuKho
    (
        LogID      INT IDENTITY(1,1) PRIMARY KEY,
        ThoiGian   DATETIME      NOT NULL DEFAULT GETDATE(),
        LoaiPhieu  NVARCHAR(10)  NOT NULL,   -- 'PN' hay 'PX'
        SoChungTu  VARCHAR(15)   NOT NULL,   -- MaPN / MaPX
        HanhDong   NVARCHAR(10)  NOT NULL,   -- INSERT / UPDATE / DELETE
        MaNV       VARCHAR(10)       NULL,   -- Nhân viên lập / sửa
        GhiChu     NVARCHAR(200)     NULL
    );
END;
GO

--Trigger log cho PHIẾU NHẬP
IF OBJECT_ID('dbo.TRG_PhieuNhap_LogChungTuKho', 'TR') IS NOT NULL
    DROP TRIGGER dbo.TRG_PhieuNhap_LogChungTuKho;
GO

CREATE TRIGGER dbo.TRG_PhieuNhap_LogChungTuKho
ON dbo.tbl_PhieuNhap
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- INSERT
    INSERT INTO dbo.tbl_LogChungTuKho (LoaiPhieu, SoChungTu, HanhDong, MaNV, GhiChu)
    SELECT 
        N'PN', i.MaPN, N'INSERT', i.MaNV, i.GhiChu
    FROM inserted i
    LEFT JOIN deleted d ON i.MaPN = d.MaPN
    WHERE d.MaPN IS NULL;

    -- DELETE
    INSERT INTO dbo.tbl_LogChungTuKho (LoaiPhieu, SoChungTu, HanhDong, MaNV, GhiChu)
    SELECT 
        N'PN', d.MaPN, N'DELETE', d.MaNV, d.GhiChu
    FROM deleted d
    LEFT JOIN inserted i ON i.MaPN = d.MaPN
    WHERE i.MaPN IS NULL;

    -- UPDATE
    INSERT INTO dbo.tbl_LogChungTuKho (LoaiPhieu, SoChungTu, HanhDong, MaNV, GhiChu)
    SELECT 
        N'PN', i.MaPN, N'UPDATE', i.MaNV, i.GhiChu
    FROM inserted i
    JOIN deleted  d ON i.MaPN = d.MaPN;
END;
GO

--Trigger log cho PHIẾU XUẤT
IF OBJECT_ID('dbo.TRG_PhieuXuat_LogChungTuKho', 'TR') IS NOT NULL
    DROP TRIGGER dbo.TRG_PhieuXuat_LogChungTuKho;
GO

CREATE TRIGGER dbo.TRG_PhieuXuat_LogChungTuKho
ON dbo.tbl_PhieuXuat
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- INSERT
    INSERT INTO dbo.tbl_LogChungTuKho (LoaiPhieu, SoChungTu, HanhDong, MaNV, GhiChu)
    SELECT 
        N'PX', i.MaPX, N'INSERT', i.MaNV, i.GhiChu
    FROM inserted i
    LEFT JOIN deleted d ON i.MaPX = d.MaPX
    WHERE d.MaPX IS NULL;

    -- DELETE
    INSERT INTO dbo.tbl_LogChungTuKho (LoaiPhieu, SoChungTu, HanhDong, MaNV, GhiChu)
    SELECT 
        N'PX', d.MaPX, N'DELETE', d.MaNV, d.GhiChu
    FROM deleted d
    LEFT JOIN inserted i ON i.MaPX = d.MaPX
    WHERE i.MaPX IS NULL;

    -- UPDATE
    INSERT INTO dbo.tbl_LogChungTuKho (LoaiPhieu, SoChungTu, HanhDong, MaNV, GhiChu)
    SELECT 
        N'PX', i.MaPX, N'UPDATE', i.MaNV, i.GhiChu
    FROM inserted i
    JOIN deleted  d ON i.MaPX = d.MaPX;
END;
GO
-- Tạo phiếu nhập mới
INSERT INTO dbo.tbl_PhieuNhap (MaPN, NgayNhap, GhiChu, MaNV)
VALUES ('PN_LOG', '2023-10-05', N'Nhập log test', 'NV007');

-- Sửa lại ghi chú
UPDATE dbo.tbl_PhieuNhap
SET GhiChu = N'Phiếu nhập hàng'
WHERE MaPN = 'PN_LOG';

-- Xóa phiếu
DELETE FROM dbo.tbl_PhieuNhap
WHERE MaPN = 'PN_LOG';

-- Xem log chứng từ kho
SELECT *
FROM dbo.tbl_LogChungTuKho
ORDER BY LogID DESC;

--TRG_CTPhieuNhap_ValidateSoLuongGiaNhap: Không cho nhập kho với số lượng hoặc giá ≤ 0
--→ Bảo vệ dữ liệu kho, tránh trường hợp gõ nhầm.
USE [WINMART];
GO

IF OBJECT_ID('dbo.TRG_CTPhieuNhap_ValidateSoLuongGiaNhap', 'TR') IS NOT NULL
    DROP TRIGGER dbo.TRG_CTPhieuNhap_ValidateSoLuongGiaNhap;
GO

CREATE TRIGGER dbo.TRG_CTPhieuNhap_ValidateSoLuongGiaNhap
ON dbo.tbl_CTPhieuNhap
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Nếu có dòng nào SoLuongNhap <= 0 hoặc GiaNhap <= 0 thì chặn
    IF EXISTS
    (
        SELECT 1
        FROM inserted
        WHERE SoLuongNhap <= 0 OR GiaNhap <= 0
    )
    BEGIN
        RAISERROR (N'Số lượng nhập và giá nhập phải lớn hơn 0.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
END;
GO

-- Tạo phiếu nhập test
INSERT INTO dbo.tbl_PhieuNhap (MaPN, NgayNhap, GhiChu, MaNV)
VALUES ('PN_ERR', '2023-10-01', N'Nhập test lỗi', 'NV007');

-- Cố tình nhập số lượng = 0 (hoặc giá = 0)
INSERT INTO dbo.tbl_CTPhieuNhap (MaPN, MaMH, SoLuongNhap, GiaNhap)
VALUES ('PN_ERR', 'MH001', 0, 25000); --Báo lỗi

--TRG_CTPhieuNhap_CheckGiaNhapVsGiaBan: Không cho nhập giá cao hơn giá bán lẻ hiện tại
--→ Quy tắc kinh doanh: giá nhập phải ≤ giá bán; nếu không thì thủ kho phải báo lại cho quản lý.
USE [WINMART];
GO

IF OBJECT_ID('dbo.TRG_CTPhieuNhap_CheckGiaNhapVsGiaBan', 'TR') IS NOT NULL
    DROP TRIGGER dbo.TRG_CTPhieuNhap_CheckGiaNhapVsGiaBan;
GO

CREATE TRIGGER dbo.TRG_CTPhieuNhap_CheckGiaNhapVsGiaBan
ON dbo.tbl_CTPhieuNhap
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Kiểm tra: Giá nhập không được cao hơn Giá bán lẻ hiện tại
    IF EXISTS
    (
        SELECT 1
        FROM inserted i
        JOIN dbo.tbl_MatHang mh ON i.MaMH = mh.MaMH
        WHERE i.GiaNhap > mh.GiaBan
    )
    BEGIN
        RAISERROR(
            N'Giá nhập không được lớn hơn giá bán lẻ hiện tại. Vui lòng kiểm tra lại.',
            16, 1
        );
        ROLLBACK TRANSACTION;
        RETURN;
    END
END;
GO

-- Phiếu nhập mới
INSERT INTO dbo.tbl_PhieuNhap (MaPN, NgayNhap, GhiChu, MaNV)
VALUES ('PN_GIA', '2023-10-02', N'Nhập test giá cao', 'NV007');

-- MH001 có GiaBan = 32000, thử nhập GiaNhap = 40000
INSERT INTO dbo.tbl_CTPhieuNhap (MaPN, MaMH, SoLuongNhap, GiaNhap)
VALUES ('PN_GIA', 'MH001', 10, 40000);

-------ỨNG DỤNG CHO NGƯỜI QUẢN LÝ---
--1.ỨNG DỤNG VIEW
USE [WINMART];
GO

IF OBJECT_ID('dbo.vw_QL_BaoCaoDoanhThuNgay', 'V') IS NOT NULL
    DROP VIEW dbo.vw_QL_BaoCaoDoanhThuNgay;
GO

CREATE VIEW dbo.vw_QL_BaoCaoDoanhThuNgay
AS
SELECT 
    hd.NgayBan,
    TongDoanhThu        = SUM(ct.SoLuongBan * ct.GiaBan),
    SoHoaDon            = COUNT(DISTINCT hd.MaHD),
    TongSoLuongBan      = SUM(ct.SoLuongBan),
    DoanhThuTB_MoiHoaDon =
        CAST(SUM(ct.SoLuongBan * ct.GiaBan) AS DECIMAL(18,2)) /
        NULLIF(COUNT(DISTINCT hd.MaHD),0)
FROM dbo.tbl_HoaDon  AS hd
JOIN dbo.tbl_CTHoaDon AS ct ON hd.MaHD = ct.MaHD
GROUP BY hd.NgayBan;
GO

SELECT *
FROM dbo.vw_QL_BaoCaoDoanhThuNgay
ORDER BY NgayBan;

--vw_QL_BaoCaoDoanhThuNhanVien: Xếp hạng hiệu quả nhân viên bán hàng / thu ngân
IF OBJECT_ID('dbo.vw_QL_BaoCaoDoanhThuNhanVien', 'V') IS NOT NULL
    DROP VIEW dbo.vw_QL_BaoCaoDoanhThuNhanVien;
GO

CREATE VIEW dbo.vw_QL_BaoCaoDoanhThuNhanVien
AS
SELECT 
    nv.MaNV,
    nv.HoTenNV,
    TongDoanhThu   = ISNULL(SUM(ct.SoLuongBan * ct.GiaBan), 0),
    SoHoaDon       = ISNULL(COUNT(DISTINCT hd.MaHD), 0),
    TongSoLuongBan = ISNULL(SUM(ct.SoLuongBan), 0)
FROM dbo.tbl_NhanVien nv
LEFT JOIN dbo.tbl_HoaDon  hd ON nv.MaNV = hd.MaNV
LEFT JOIN dbo.tbl_CTHoaDon ct ON hd.MaHD = ct.MaHD
GROUP BY nv.MaNV, nv.HoTenNV;
GO

--Bối cảnh dùng: Manager muốn biết nhân viên nào bán tốt nhất, để thưởng KPI, đào tạo thêm…
--Ví dụ top 5 NV doanh thu cao nhất:
SELECT TOP 5 *
FROM dbo.vw_QL_BaoCaoDoanhThuNhanVien
ORDER BY TongDoanhThu DESC;

--vw_QL_BaoCaoDoanhThuMatHang: Phân tích sản phẩm bán chạy / mang nhiều doanh thu
IF OBJECT_ID('dbo.vw_QL_BaoCaoDoanhThuMatHang', 'V') IS NOT NULL
    DROP VIEW dbo.vw_QL_BaoCaoDoanhThuMatHang;
GO

CREATE VIEW dbo.vw_QL_BaoCaoDoanhThuMatHang
AS
SELECT 
    mh.MaMH,
    mh.TenMH,
    lh.TenLH           AS TenLoaiHang,
    TongSoLuongBan = ISNULL(SUM(ct.SoLuongBan), 0),
    TongDoanhThu   = ISNULL(SUM(ct.SoLuongBan * ct.GiaBan), 0)
FROM dbo.tbl_MatHang  mh
LEFT JOIN dbo.tbl_LoaiHang   lh ON mh.MaLH = lh.MaLH
LEFT JOIN dbo.tbl_CTHoaDon   ct ON mh.MaMH = ct.MaMH
LEFT JOIN dbo.tbl_HoaDon     hd ON ct.MaHD = hd.MaHD
GROUP BY mh.MaMH, mh.TenMH, lh.TenLH;
GO

--Bối cảnh dùng: Quản lý muốn biết:
--Mặt hàng nào bán chạy nhất?
--Nhóm hàng nào mang nhiều doanh thu?
--Ví dụ:
-- Top 10 mặt hàng doanh thu cao nhất
SELECT TOP 10 *
FROM dbo.vw_QL_BaoCaoDoanhThuMatHang
ORDER BY TongDoanhThu DESC;

--vw_QL_TonKho_GiaTriHienTai: Theo dõi tồn kho & giá trị tồn theo từng mặt hàng
IF OBJECT_ID('dbo.vw_QL_TonKho_GiaTriHienTai', 'V') IS NOT NULL
    DROP VIEW dbo.vw_QL_TonKho_GiaTriHienTai;
GO

CREATE VIEW dbo.vw_QL_TonKho_GiaTriHienTai
AS
SELECT 
    mh.MaMH,
    mh.TenMH,
    lh.TenLH             AS TenLoaiHang,
    ncc.TenNCC           AS TenNhaCungCap,
    mh.DonViTinh,
    mh.GiaBan,
    mh.SoLuongTon,
    GiaTriTon = CAST(mh.SoLuongTon * mh.GiaBan AS DECIMAL(18,2))
FROM dbo.tbl_MatHang    mh
JOIN dbo.tbl_LoaiHang   lh  ON mh.MaLH  = lh.MaLH
JOIN dbo.tbl_NhaCungCap ncc ON mh.MaNCC = ncc.MaNCC;
GO

-- Top 5 mặt hàng tồn giá trị cao nhất
SELECT TOP 5 *
FROM dbo.vw_QL_TonKho_GiaTriHienTai
ORDER BY GiaTriTon DESC;

--vw_QL_NhapXuatTon_TongHop: Tổng hợp Nhập – Xuất kho – Bán – Tồn hệ thống vs tồn thực tế
IF OBJECT_ID('dbo.vw_QL_NhapXuatTon_TongHop', 'V') IS NOT NULL
    DROP VIEW dbo.vw_QL_NhapXuatTon_TongHop;
GO

CREATE VIEW dbo.vw_QL_NhapXuatTon_TongHop
AS
WITH Nhap AS
(
    SELECT ctn.MaMH, SUM(ctn.SoLuongNhap) AS TongNhap
    FROM dbo.tbl_CTPhieuNhap ctn
    GROUP BY ctn.MaMH
),
XuatKho AS
(
    SELECT ctx.MaMH, SUM(ctx.SoLuongXuat) AS TongXuatKho
    FROM dbo.tbl_CTPhieuXuat ctx
    GROUP BY ctx.MaMH
),
Ban AS
(
    SELECT cthd.MaMH, SUM(cthd.SoLuongBan) AS TongBan
    FROM dbo.tbl_CTHoaDon cthd
    GROUP BY cthd.MaMH
)
SELECT 
    mh.MaMH,
    mh.TenMH,
    ISNULL(n.TongNhap, 0)   AS TongNhap,
    ISNULL(x.TongXuatKho,0) AS TongXuatKho,
    ISNULL(b.TongBan, 0)    AS TongBan,
    TonHeThong = ISNULL(n.TongNhap, 0)
                 - ISNULL(x.TongXuatKho,0)
                 - ISNULL(b.TongBan,0),
    TonKhoThucTe = mh.SoLuongTon
FROM dbo.tbl_MatHang mh
LEFT JOIN Nhap    n ON mh.MaMH = n.MaMH
LEFT JOIN XuatKho x ON mh.MaMH = x.MaMH
LEFT JOIN Ban     b ON mh.MaMH = b.MaMH;
GO

--Bối cảnh dùng:
--View này là “báo cáo NXT tổng hợp” cho từng mã hàng:
--TongNhap – tổng đã nhập
--TongXuatKho – tổng đã xuất kho
--TongBan – tổng đã bán qua hóa đơn
--TonHeThong – tồn tính theo chứng từ
--TonKhoThucTe – tồn lưu trong tbl_MatHang.SoLuongTon

-- Toàn bộ báo cáo Nhập-Xuất-Tồn
SELECT *
FROM dbo.vw_QL_NhapXuatTon_TongHop;

-- Tìm mặt hàng có sai lệch giữa tồn hệ thống và tồn thực tế
SELECT *
FROM dbo.vw_QL_NhapXuatTon_TongHop
WHERE TonHeThong <> TonKhoThucTe;

--2. ỨNG DỤNG INDEX
--IDX_HoaDon_NgayBan: Tăng tốc mọi báo cáo doanh thu theo ngày
USE WINMART;
GO

IF EXISTS (SELECT 1 FROM sys.indexes 
           WHERE name = 'IDX_HoaDon_NgayBan'
             AND object_id = OBJECT_ID('dbo.tbl_HoaDon'))
    DROP INDEX IDX_HoaDon_NgayBan ON dbo.tbl_HoaDon;
GO

CREATE NONCLUSTERED INDEX IDX_HoaDon_NgayBan
ON dbo.tbl_HoaDon (NgayBan);
GO

--Bối cảnh: Quản lý thường xem báo cáo: Doanh thu từng ngày, số hoá đơn mỗi ngày, so sánh doanh thu giữa các ngày

SELECT *
FROM dbo.vw_QL_BaoCaoDoanhThuNgay
ORDER BY NgayBan;

--Khi số lượng hóa đơn lớn, query vẫn chạy nhanh nhờ index trên NgayBan.
--IDX_HoaDon_MaNV_NgayBan: Phân tích doanh thu theo NHÂN VIÊN và theo NGÀY
IF EXISTS (SELECT 1 FROM sys.indexes 
           WHERE name = 'IDX_HoaDon_MaNV_NgayBan'
             AND object_id = OBJECT_ID('dbo.tbl_HoaDon'))
    DROP INDEX IDX_HoaDon_MaNV_NgayBan ON dbo.tbl_HoaDon;
GO

CREATE NONCLUSTERED INDEX IDX_HoaDon_MaNV_NgayBan
ON dbo.tbl_HoaDon (MaNV, NgayBan)
INCLUDE (MaHD, MaKH);
GO

--Quản lý muốn: Xem doanh thu theo từng nhân viên, Lọc theo khoảng thời gian (tháng, quý…)
--Dùng view vw_QL_BaoCaoDoanhThuNhanVien hoặc report chi tiết theo ngày.

-- Doanh thu theo ngày của nhân viên NV010
SELECT hd.MaNV, nv.HoTenNV, hd.NgayBan,
       SUM(ct.SoLuongBan * ct.GiaBan) AS DoanhThu
FROM dbo.tbl_HoaDon hd
JOIN dbo.tbl_CTHoaDon ct ON hd.MaHD = ct.MaHD
JOIN dbo.tbl_NhanVien nv ON nv.MaNV = hd.MaNV
WHERE hd.MaNV = 'NV010'
  AND hd.NgayBan BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY hd.MaNV, nv.HoTenNV, hd.NgayBan;

--IDX_CTHoaDon_MaMH: Phân tích sản phẩm bán chạy / doanh thu theo MẶT HÀNG
IF EXISTS (SELECT 1 FROM sys.indexes 
           WHERE name = 'IDX_CTHoaDon_MaMH'
             AND object_id = OBJECT_ID('dbo.tbl_CTHoaDon'))
    DROP INDEX IDX_CTHoaDon_MaMH ON dbo.tbl_CTHoaDon;
GO

CREATE NONCLUSTERED INDEX IDX_CTHoaDon_MaMH
ON dbo.tbl_CTHoaDon (MaMH)
INCLUDE (SoLuongBan, GiaBan, MaHD);
GO

--Bối cảnh: Các báo cáo: vw_QL_BaoCaoDoanhThuMatHang – tổng số lượng bán, tổng doanh thu theo từng sản phẩm

-- Top 3 sản phẩm doanh thu cao nhất
SELECT TOP 3 *
FROM dbo.vw_QL_BaoCaoDoanhThuMatHang
ORDER BY TongDoanhThu DESC;

--IDX_MatHang_Loai_NCC – Phân tích TỒN KHO theo LOẠI HÀNG & NHÀ CUNG CẤP
IF EXISTS (SELECT 1 FROM sys.indexes 
           WHERE name = 'IDX_MatHang_Loai_NCC'
             AND object_id = OBJECT_ID('dbo.tbl_MatHang'))
    DROP INDEX IDX_MatHang_Loai_NCC ON dbo.tbl_MatHang;
GO

CREATE NONCLUSTERED INDEX IDX_MatHang_Loai_NCC
ON dbo.tbl_MatHang (MaLH, MaNCC)
INCLUDE (TenMH, GiaBan, SoLuongTon);
GO

--Bối cảnh: Quản lý muốn các phân tích nâng cao về kho:

-- Giá trị tồn theo từng LOẠI HÀNG
SELECT lh.TenLH,
       SUM(mh.SoLuongTon * mh.GiaBan) AS GiaTriTon
FROM dbo.tbl_MatHang   mh
JOIN dbo.tbl_LoaiHang  lh  ON mh.MaLH  = lh.MaLH
GROUP BY lh.TenLH;

-- Giá trị tồn theo từng NHÀ CUNG CẤP
SELECT ncc.TenNCC,
       SUM(mh.SoLuongTon * mh.GiaBan) AS GiaTriTon
FROM dbo.tbl_MatHang   mh
JOIN dbo.tbl_NhaCungCap ncc ON mh.MaNCC = ncc.MaNCC
GROUP BY ncc.TenNCC;

--3.ỨNG DỤNG PRODUCE
--usp_QL_BaoCaoDoanhThuTongHopNgay: Báo cáo doanh thu theo ngày trong khoảng thời gian
USE WINMART;
GO

IF OBJECT_ID('dbo.usp_QL_BaoCaoDoanhThuTongHopNgay', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_QL_BaoCaoDoanhThuTongHopNgay;
GO

CREATE PROCEDURE dbo.usp_QL_BaoCaoDoanhThuTongHopNgay
(
    @TuNgay  DATE = NULL,
    @DenNgay DATE = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    IF @TuNgay IS NULL SET @TuNgay = '2023-01-01';
    IF @DenNgay IS NULL SET @DenNgay = '2025-12-31';

    SELECT 
        hd.NgayBan,
        TongDoanhThu        = SUM(ct.SoLuongBan * ct.GiaBan),
        SoHoaDon            = COUNT(DISTINCT hd.MaHD),
        TongSoLuongBan      = SUM(ct.SoLuongBan),
        DoanhThuTB_MoiHoaDon =
            CAST(SUM(ct.SoLuongBan * ct.GiaBan) AS DECIMAL(18,2))
            / NULLIF(COUNT(DISTINCT hd.MaHD), 0)
    FROM dbo.tbl_HoaDon  hd
    JOIN dbo.tbl_CTHoaDon ct ON hd.MaHD = ct.MaHD
    WHERE hd.NgayBan BETWEEN @TuNgay AND @DenNgay
    GROUP BY hd.NgayBan
    ORDER BY hd.NgayBan;
END;
GO

--Bối cảnh: Quản lý xem doanh thu từng ngày, số hóa đơn, hóa đơn trung bình 
EXEC dbo.usp_QL_BaoCaoDoanhThuTongHopNgay
    @TuNgay  = '2024-01-01',
    @DenNgay = '2024-12-31';

--usp_QL_BaoCaoDoanhThuNhanVien: Xếp hạng nhân viên theo doanh thu
IF OBJECT_ID('dbo.usp_QL_BaoCaoDoanhThuNhanVien', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_QL_BaoCaoDoanhThuNhanVien;
GO

CREATE PROCEDURE dbo.usp_QL_BaoCaoDoanhThuNhanVien
(
    @TuNgay  DATE = NULL,
    @DenNgay DATE = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    IF @TuNgay IS NULL SET @TuNgay = '2020-01-01';
    IF @DenNgay IS NULL SET @DenNgay = '2025-12-31';

    SELECT 
        nv.MaNV,
        nv.HoTenNV,
        TongDoanhThu   = ISNULL(SUM(ct.SoLuongBan * ct.GiaBan), 0),
        SoHoaDon       = ISNULL(COUNT(DISTINCT hd.MaHD), 0),
        TongSoLuongBan = ISNULL(SUM(ct.SoLuongBan), 0)
    FROM dbo.tbl_NhanVien nv
    LEFT JOIN dbo.tbl_HoaDon  hd 
         ON nv.MaNV = hd.MaNV
        AND hd.NgayBan BETWEEN @TuNgay AND @DenNgay
    LEFT JOIN dbo.tbl_CTHoaDon ct ON hd.MaHD = ct.MaHD
    GROUP BY nv.MaNV, nv.HoTenNV
    ORDER BY TongDoanhThu DESC;
END;
GO

--Bối cảnh: Quản lý muốn biết nhân viên nào bán tốt nhất trong tháng/năm để đánh giá, thưởng KPI.
EXEC dbo.usp_QL_BaoCaoDoanhThuNhanVien
    @TuNgay  = '2024-01-01',
    @DenNgay = '2024-12-31';

--usp_QL_BaoCaoTopMatHang: Top những mặt hàng có doanh thu cao nhất / bán chạy nhất
IF OBJECT_ID('dbo.usp_QL_BaoCaoTopMatHang', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_QL_BaoCaoTopMatHang;
GO

CREATE PROCEDURE dbo.usp_QL_BaoCaoTopMatHang
(
    @TuNgay  DATE = NULL,
    @DenNgay DATE = NULL,
    @TopN    INT  = 10
)
AS
BEGIN
    SET NOCOUNT ON;

    IF @TuNgay IS NULL SET @TuNgay = '2024-01-01';
    IF @DenNgay IS NULL SET @DenNgay = '2024-12-31';
    IF @TopN IS NULL OR @TopN <= 0 SET @TopN = 10;

    ;WITH DoanhThuSP AS
    (
        SELECT 
            mh.MaMH,
            mh.TenMH,
            lh.TenLH              AS TenLoaiHang,
            TongSoLuongBan = SUM(ct.SoLuongBan),
            TongDoanhThu   = SUM(ct.SoLuongBan * ct.GiaBan)
        FROM dbo.tbl_CTHoaDon ct
        JOIN dbo.tbl_HoaDon   hd ON ct.MaHD = hd.MaHD
        JOIN dbo.tbl_MatHang  mh ON ct.MaMH = mh.MaMH
        JOIN dbo.tbl_LoaiHang lh ON mh.MaLH = lh.MaLH
        WHERE hd.NgayBan BETWEEN @TuNgay AND @DenNgay
        GROUP BY mh.MaMH, mh.TenMH, lh.TenLH
    )
    SELECT TOP (@TopN) *
    FROM DoanhThuSP
    ORDER BY TongDoanhThu DESC, TongSoLuongBan DESC;
END;
GO

--Bối cảnh: Quản lý muốn biết sản phẩm nào mang nhiều doanh thu nhất để ưu tiên nhập hàng, trưng bày, khuyến mãi.
EXEC dbo.usp_QL_BaoCaoTopMatHang
    @TuNgay  = '2024-01-01',
    @DenNgay = '2024-12-31',
    @TopN    = 5;

    --usp_QL_BaoCaoTopKhachHang: Top những khách hàng chi tiêu nhiều nhất (khách hàng thân thiết)
IF OBJECT_ID('dbo.usp_QL_BaoCaoTopKhachHang', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_QL_BaoCaoTopKhachHang;
GO

CREATE PROCEDURE dbo.usp_QL_BaoCaoTopKhachHang
(
    @TuNgay  DATE = NULL,
    @DenNgay DATE = NULL,
    @TopN    INT = 10
)
AS
BEGIN
    SET NOCOUNT ON;

    IF @TuNgay IS NULL SET @TuNgay = '2023-01-01';
    IF @DenNgay IS NULL SET @DenNgay = '2023-12-31';
    IF @TopN IS NULL OR @TopN <= 0 SET @TopN = 10;

    ;WITH ChiTieuKH AS
    (
        SELECT
            kh.MaKH,
            kh.HoTenKH,
            kh.DienThoai,
            SoHoaDon   = COUNT(DISTINCT hd.MaHD),
            TongChiTieu = SUM(ct.SoLuongBan * ct.GiaBan)
        FROM dbo.tbl_KhachHang kh
        JOIN dbo.tbl_HoaDon    hd ON kh.MaKH = hd.MaKH
        JOIN dbo.tbl_CTHoaDon  ct ON hd.MaHD = ct.MaHD
        WHERE hd.NgayBan BETWEEN @TuNgay AND @DenNgay
        GROUP BY kh.MaKH, kh.HoTenKH, kh.DienThoai
    )
    SELECT TOP (@TopN) *
    FROM ChiTieuKH
    ORDER BY TongChiTieu DESC, SoHoaDon DESC;
END;
GO

--Bối cảnh: Dùng để nhận diện khách hàng VIP, chi tiêu nhiều → gửi ưu đãi, chăm sóc riêng.

EXEC dbo.usp_QL_BaoCaoTopKhachHang
    @TuNgay  = '2024-01-01',
    @DenNgay = '2024-12-31',
    @TopN    = 5;

--usp_QL_BaoCaoTonKhoTongHop: Báo cáo tồn kho + giá trị tồn hiện tại, có lọc theo loại hàng / nhà cung cấp
IF OBJECT_ID('dbo.usp_QL_BaoCaoTonKhoTongHop', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_QL_BaoCaoTonKhoTongHop;
GO

CREATE PROCEDURE dbo.usp_QL_BaoCaoTonKhoTongHop
(
    @MaLH  VARCHAR(10) = NULL,   -- lọc theo loại hàng (optional)
    @MaNCC VARCHAR(10) = NULL    -- lọc theo nhà cung cấp (optional)
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        mh.MaMH,
        mh.TenMH,
        lh.TenLH             AS TenLoaiHang,
        ncc.TenNCC           AS TenNhaCungCap,
        mh.DonViTinh,
        mh.GiaBan,
        mh.SoLuongTon,
        GiaTriTon = CAST(mh.SoLuongTon * mh.GiaBan AS DECIMAL(18,2))
    FROM dbo.tbl_MatHang    mh
    JOIN dbo.tbl_LoaiHang   lh  ON mh.MaLH  = lh.MaLH
    JOIN dbo.tbl_NhaCungCap ncc ON mh.MaNCC = ncc.MaNCC
    WHERE (@MaLH  IS NULL OR mh.MaLH  = @MaLH)
      AND (@MaNCC IS NULL OR mh.MaNCC = @MaNCC)
    ORDER BY GiaTriTon DESC;
END;
GO

--Bối cảnh: Quản lý muốn xem:
--Tổng tồn kho, giá trị tồn
--Tồn theo 1 loại hàng (ví dụ sữa, bánh kẹo)
--Tồn theo 1 nhà cung cấp

-- Toàn bộ tồn kho hiện tại
EXEC dbo.usp_QL_BaoCaoTonKhoTongHop
    @MaLH = NULL, @MaNCC = NULL;

    -- Tồn kho riêng nhóm "Sữa và sản phẩm từ sữa" (LH01)
EXEC dbo.usp_QL_BaoCaoTonKhoTongHop
    @MaLH = 'LH01', @MaNCC = NULL;

--usp_QL_BaoCaoNhapXuatTonTongHop: Báo cáo Nhập – Xuất kho – Bán – Tồn hệ thống vs tồn thực tế
IF OBJECT_ID('dbo.usp_QL_BaoCaoNhapXuatTonTongHop', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_QL_BaoCaoNhapXuatTonTongHop;
GO

CREATE PROCEDURE dbo.usp_QL_BaoCaoNhapXuatTonTongHop
AS
BEGIN
    SET NOCOUNT ON;

    ;WITH Nhap AS
    (
        SELECT ctn.MaMH, SUM(ctn.SoLuongNhap) AS TongNhap
        FROM dbo.tbl_CTPhieuNhap ctn
        GROUP BY ctn.MaMH
    ),
    XuatKho AS
    (
        SELECT ctx.MaMH, SUM(ctx.SoLuongXuat) AS TongXuatKho
        FROM dbo.tbl_CTPhieuXuat ctx
        GROUP BY ctx.MaMH
    ),
    Ban AS
    (
        SELECT cthd.MaMH, SUM(cthd.SoLuongBan) AS TongBan
        FROM dbo.tbl_CTHoaDon cthd
        GROUP BY cthd.MaMH
    )
    SELECT 
        mh.MaMH,
        mh.TenMH,
        ISNULL(n.TongNhap, 0)   AS TongNhap,
        ISNULL(x.TongXuatKho,0) AS TongXuatKho,
        ISNULL(b.TongBan, 0)    AS TongBan,
        TonHeThong = ISNULL(n.TongNhap, 0)
                     - ISNULL(x.TongXuatKho,0)
                     - ISNULL(b.TongBan,0),
        TonKhoThucTe = mh.SoLuongTon
    FROM dbo.tbl_MatHang mh
    LEFT JOIN Nhap    n ON mh.MaMH = n.MaMH
    LEFT JOIN XuatKho x ON mh.MaMH = x.MaMH
    LEFT JOIN Ban     b ON mh.MaMH = b.MaMH
    ORDER BY mh.MaMH;
END;
GO

--Bối cảnh: Quản lý muốn đối chiếu giữa:

DECLARE @KQ TABLE
(
    MaMH         VARCHAR(10),
    TenMH        NVARCHAR(100),
    TongNhap     INT,
    TongXuatKho  INT,
    TongBan      INT,
    TonHeThong   INT,
    TonKhoThucTe INT
);


INSERT INTO @KQ
EXEC dbo.usp_QL_BaoCaoNhapXuatTonTongHop;

-- Lọc các mặt hàng có sai lệch giữa tồn hệ thống và tồn thực tế
SELECT *
FROM @KQ
WHERE TonHeThong <> TonKhoThucTe;

--usp_QL_CapNhatGiaBan_MatHang + tbl_LogGiaBan: Cập nhật giá bán mặt hàng, kiểm tra không bán lỗ và ghi log lịch sử giá

--Bảng log lịch sử giá bán
IF OBJECT_ID('dbo.tbl_LogGiaBan', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.tbl_LogGiaBan
    (
        LogID        INT IDENTITY(1,1) PRIMARY KEY,
        ThoiGian     DATETIME      NOT NULL DEFAULT GETDATE(),
        MaMH         VARCHAR(10)   NOT NULL,
        GiaBan_Cu    DECIMAL(18,2) NOT NULL,
        GiaBan_Moi   DECIMAL(18,2) NOT NULL,
        MaNVQuanLy   VARCHAR(10)       NULL,
        GhiChu       NVARCHAR(200)     NULL
    );
END;
GO

--Procedure cập nhật giá
IF OBJECT_ID('dbo.usp_QL_CapNhatGiaBan_MatHang', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_QL_CapNhatGiaBan_MatHang;
GO

CREATE PROCEDURE dbo.usp_QL_CapNhatGiaBan_MatHang
(
    @MaMH        VARCHAR(10),
    @GiaBanMoi   DECIMAL(18,2),
    @MaNVQuanLy  VARCHAR(10),
    @GhiChu      NVARCHAR(200) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRAN;

        -- 1. Kiểm tra mặt hàng tồn tại
        IF NOT EXISTS (SELECT 1 FROM dbo.tbl_MatHang WHERE MaMH = @MaMH)
        BEGIN
            RAISERROR (N'Mặt hàng %s không tồn tại.', 16, 1, @MaMH);
            ROLLBACK TRAN;
            RETURN;
        END;

        -- 2. Giá mới > 0
        IF @GiaBanMoi <= 0
        BEGIN
            RAISERROR (N'Giá bán mới phải lớn hơn 0.', 16, 1);
            ROLLBACK TRAN;
            RETURN;
        END;

        DECLARE @GiaBanCu   DECIMAL(18,2);
        DECLARE @GiaNhapMax DECIMAL(18,2);

        SELECT @GiaBanCu = GiaBan
        FROM dbo.tbl_MatHang
        WHERE MaMH = @MaMH;

        SELECT @GiaNhapMax = MAX(GiaNhap)
        FROM dbo.tbl_CTPhieuNhap
        WHERE MaMH = @MaMH;

        -- 3. Không cho giá bán mới thấp hơn giá nhập lớn nhất 
        IF @GiaNhapMax IS NOT NULL AND @GiaBanMoi < @GiaNhapMax
        BEGIN
            
            DECLARE @GiaMoiText  NVARCHAR(50) = CONVERT(NVARCHAR(50), @GiaBanMoi);
            DECLARE @GiaNhapText NVARCHAR(50) = CONVERT(NVARCHAR(50), @GiaNhapMax);

            RAISERROR(
                N'Giá bán mới (%s) thấp hơn giá nhập gần nhất (%s), có nguy cơ bán lỗ.',
                16, 1, @GiaMoiText, @GiaNhapText
            );
            ROLLBACK TRAN;
            RETURN;
        END;

        -- 4. Cập nhật giá
        UPDATE dbo.tbl_MatHang
        SET GiaBan = @GiaBanMoi
        WHERE MaMH = @MaMH;

        -- 5. Ghi log
        INSERT INTO dbo.tbl_LogGiaBan
            (MaMH, GiaBan_Cu, GiaBan_Moi, MaNVQuanLy, GhiChu)
        VALUES
            (@MaMH, @GiaBanCu, @GiaBanMoi, @MaNVQuanLy, @GhiChu);

        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRAN;

        DECLARE @ErrMsg NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrMsg, 16, 1);
    END CATCH
END;
GO

--Bối cảnh: Quản lý điều chỉnh giá bán (tăng/giảm), nhưng:
--Không muốn nhập nhầm giá = 0 hoặc quá thấp
--Không muốn bán dưới giá nhập → lỗ
--Cần log lại lịch sử thay đổi giá, ai đổi, đổi lúc nào, vì lý do gì

EXEC dbo.usp_QL_CapNhatGiaBan_MatHang
    @MaMH       = 'MH001',
    @GiaBanMoi  = 35000,
    @MaNVQuanLy = 'NV001',  
    @GhiChu     = N'Điều chỉnh giá theo bảng giá mới của nhà cung cấp';

-- Kiểm tra giá mới
SELECT MaMH, TenMH, GiaBan
FROM dbo.tbl_MatHang
WHERE MaMH = 'MH001';

-- Kiểm tra lịch sử thay đổi giá
SELECT *
FROM dbo.tbl_LogGiaBan
WHERE MaMH = 'MH001'
ORDER BY LogID DESC;

--usp_QL_BaoCaoLoiNhuanTheoMatHang: Báo cáo lợi nhuận theo mặt hàng 
USE WINMART;
GO

IF OBJECT_ID('dbo.usp_QL_BaoCaoLoiNhuanTheoMatHang', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_QL_BaoCaoLoiNhuanTheoMatHang;
GO

CREATE PROCEDURE dbo.usp_QL_BaoCaoLoiNhuanTheoMatHang
(
    @TuNgay              DATE        = NULL,   
    @DenNgay             DATE        = NULL,
    @ChiHienThiLo        BIT         = 0,      
    @NguongTyLeLoiNhuan  DECIMAL(5,2) = 5.00   
)
AS
BEGIN
    SET NOCOUNT ON;

    IF @TuNgay IS NULL SET @TuNgay = '1900-01-01';
    IF @DenNgay IS NULL SET @DenNgay = '9999-12-31';

    ;WITH Ban AS
    (
        SELECT 
            ct.MaMH,
            TongSoLuongBan = SUM(ct.SoLuongBan),
            TongDoanhThu   = SUM(ct.SoLuongBan * ct.GiaBan)
        FROM dbo.tbl_CTHoaDon ct
        JOIN dbo.tbl_HoaDon   hd ON ct.MaHD = hd.MaHD
        WHERE hd.NgayBan BETWEEN @TuNgay AND @DenNgay
        GROUP BY ct.MaMH
    ),
    Nhap AS
    (
        SELECT 
            ctn.MaMH,
            TongSLNhap   = SUM(ctn.SoLuongNhap),
            TongTienNhap = SUM(ctn.SoLuongNhap * ctn.GiaNhap)
        FROM dbo.tbl_CTPhieuNhap ctn
        JOIN dbo.tbl_PhieuNhap   pn ON ctn.MaPN = pn.MaPN
        GROUP BY ctn.MaMH
    ),
    GiaNhapBinhQuan AS
    (
        SELECT
            n.MaMH,
            GiaNhapBinhQuan = 
                CASE 
                    WHEN n.TongSLNhap = 0 THEN NULL
                    ELSE CAST(n.TongTienNhap AS DECIMAL(18,2)) / n.TongSLNhap
                END
        FROM Nhap n
    )
   
    SELECT *
    FROM
    (
        SELECT
            mh.MaMH,
            mh.TenMH,
            lh.TenLH                AS TenLoaiHang,
            b.TongSoLuongBan,
            b.TongDoanhThu,
            gnbq.GiaNhapBinhQuan,
            TongGiaVon = 
                CASE 
                    WHEN gnbq.GiaNhapBinhQuan IS NULL THEN NULL
                    ELSE CAST(b.TongSoLuongBan AS DECIMAL(18,2)) * gnbq.GiaNhapBinhQuan
                END,
            LoiNhuan =
                CASE 
                    WHEN gnbq.GiaNhapBinhQuan IS NULL THEN NULL
                    ELSE b.TongDoanhThu 
                         - CAST(b.TongSoLuongBan AS DECIMAL(18,2)) * gnbq.GiaNhapBinhQuan
                END,
            TyLeLoiNhuan = 
                CASE 
                    WHEN b.TongDoanhThu = 0 
                         OR gnbq.GiaNhapBinhQuan IS NULL 
                    THEN NULL
                    ELSE 
                        (b.TongDoanhThu 
                         - CAST(b.TongSoLuongBan AS DECIMAL(18,2)) * gnbq.GiaNhapBinhQuan)
                        / b.TongDoanhThu * 100.0
                END
        FROM Ban              b
        JOIN dbo.tbl_MatHang  mh   ON b.MaMH = mh.MaMH
        JOIN dbo.tbl_LoaiHang lh   ON mh.MaLH = lh.MaLH
        LEFT JOIN GiaNhapBinhQuan gnbq ON b.MaMH = gnbq.MaMH
    ) AS T
    WHERE 
        @ChiHienThiLo = 0
        OR (T.TyLeLoiNhuan IS NOT NULL AND T.TyLeLoiNhuan < @NguongTyLeLoiNhuan)
    ORDER BY T.LoiNhuan DESC;
END;
GO

--Xem lợi nhuận tất cả mặt hàng trong năm 2024
EXEC dbo.usp_QL_BaoCaoLoiNhuanTheoMatHang
    @TuNgay  = '2023-01-01',
    @DenNgay = '2024-12-31',
    @ChiHienThiLo = 0;

--Chỉ xem những mặt hàng lợi nhuận thấp / có nguy cơ lỗ
EXEC dbo.usp_QL_BaoCaoLoiNhuanTheoMatHang
    @TuNgay  = '2024-01-01',
    @DenNgay = '2024-12-31',
    @ChiHienThiLo = 1,
    @NguongTyLeLoiNhuan = 20.00;   

--4.ỨNG DỤNG TRIGGER
--TRG_MatHang_KhongChoXoaMatHangDaPhatSinh: Không cho xóa mặt hàng đã từng nhập kho hoặc bán hàng
IF OBJECT_ID('dbo.TRG_MatHang_KhongChoXoaMatHangDaPhatSinh', 'TR') IS NOT NULL
    DROP TRIGGER dbo.TRG_MatHang_KhongChoXoaMatHangDaPhatSinh;
GO

CREATE TRIGGER dbo.TRG_MatHang_KhongChoXoaMatHangDaPhatSinh
ON dbo.tbl_MatHang
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- Những mã hàng đã có giao dịch (nhập / bán)
    IF EXISTS
    (
        SELECT 1
        FROM deleted d
        WHERE EXISTS (SELECT 1 FROM dbo.tbl_CTPhieuNhap ctn WHERE ctn.MaMH = d.MaMH)
           OR EXISTS (SELECT 1 FROM dbo.tbl_CTHoaDon   cthd WHERE cthd.MaMH = d.MaMH)
           OR EXISTS (SELECT 1 FROM dbo.tbl_CTPhieuXuat ctx WHERE ctx.MaMH = d.MaMH)
    )
    BEGIN
        RAISERROR (N'Mặt hàng đã phát sinh giao dịch (nhập/xuất/bán), không được phép xóa. Chỉ nên ngừng kinh doanh.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

   
    DELETE mh
    FROM dbo.tbl_MatHang mh
    JOIN deleted d ON mh.MaMH = d.MaMH;
END;
GO

--Quản lý không muốn mất dữ liệu lịch sử.
--Một mặt hàng đã từng xuất hiện trong hóa đơn / phiếu nhập thì không được xóa.

--Thử xóa mặt hàng đang dùng (ví dụ MH001 xuất hiện trong CTHoaDon & CTPhieuNhap):
DELETE FROM dbo.tbl_MatHang
WHERE MaMH = 'MH001';

INSERT INTO dbo.tbl_MatHang (MaMH, TenMH, GiaBan, SoLuongTon, DonViTinh, MaLH, MaNCC)
VALUES ('MH099', N'Hàng test xóa', 10000, 0, N'Hộp', 'LH01', 'NCC01');

DELETE FROM dbo.tbl_MatHang
WHERE MaMH = 'MH099'; --MH999 chưa xuất hiện trong phiếu nhập / hóa đơn → trigger cho phép xóa bình thường.

--TRG_HoaDon_LogSuaXoa – Ghi lịch sử sửa / xóa hóa đơn
--Bảng log cho quản lý
USE WINMART;
GO

IF OBJECT_ID('dbo.tbl_LogHoaDon', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.tbl_LogHoaDon
    (
        LogID        INT IDENTITY(1,1) PRIMARY KEY,
        MaHD         VARCHAR(10),
        HanhDong     NVARCHAR(20),   -- 'UPDATE' hoặc 'DELETE'
        NgayBan_Cu   DATE     NULL,
        NgayBan_Moi  DATE     NULL,
        MaNV_Cu      VARCHAR(10) NULL,
        MaNV_Moi     VARCHAR(10) NULL,
        MaKH_Cu      VARCHAR(10) NULL,
        MaKH_Moi     VARCHAR(10) NULL,
        ThoiGianLog  DATETIME NOT NULL DEFAULT GETDATE(),
        GhiChu       NVARCHAR(200) NULL
    );
END;
GO

--TRigger
IF OBJECT_ID('dbo.TRG_HoaDon_LogSuaXoa', 'TR') IS NOT NULL
    DROP TRIGGER dbo.TRG_HoaDon_LogSuaXoa;
GO

CREATE TRIGGER dbo.TRG_HoaDon_LogSuaXoa
ON dbo.tbl_HoaDon
AFTER UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.tbl_LogHoaDon
        (MaHD, HanhDong,
         NgayBan_Cu, NgayBan_Moi,
         MaNV_Cu, MaNV_Moi,
         MaKH_Cu, MaKH_Moi,
         GhiChu)
    SELECT
        COALESCE(d.MaHD, i.MaHD)             AS MaHD,
        CASE WHEN i.MaHD IS NULL 
             THEN N'DELETE' ELSE N'UPDATE' END AS HanhDong,
        d.NgayBan,          i.NgayBan,
        d.MaNV,             i.MaNV,
        d.MaKH,             i.MaKH,
        N'Trigger log hóa đơn cho quản lý kiểm soát.'
    FROM deleted d
    FULL JOIN inserted i
           ON d.MaHD = i.MaHD;
END;
GO

--Quản lý muốn biết:
--Ai sửa thông tin hóa đơn (đổi ngày, đổi nhân viên, đổi khách hàng).
--Hóa đơn nào bị xóa khỏi hệ thống.

--Sửa thông tin hoá đơn
UPDATE dbo.tbl_HoaDon
SET NgayBan = '2025-12-06',
    MaNV    = 'NV010'
WHERE MaHD = 'HD001';

--Quản lý xem lịch sử 
SELECT *
FROM dbo.tbl_LogHoaDon
ORDER BY LogID DESC;

--TRG_NhanVien_KhongChoXoaNhanVienDaLapChungTu
--Không cho xóa nhân viên đã từng lập hóa đơn / phiếu nhập / phiếu xuất / phiếu kiểm kê.

IF OBJECT_ID('dbo.TRG_NhanVien_KhongChoXoaNhanVienDaLapChungTu', 'TR') IS NOT NULL
    DROP TRIGGER dbo.TRG_NhanVien_KhongChoXoaNhanVienDaLapChungTu;
GO

CREATE TRIGGER dbo.TRG_NhanVien_KhongChoXoaNhanVienDaLapChungTu
ON dbo.tbl_NhanVien
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- Nhân viên có phát sinh chứng từ?
    IF EXISTS
    (
        SELECT 1
        FROM deleted d
        WHERE EXISTS (SELECT 1 FROM dbo.tbl_HoaDon      hd  WHERE hd.MaNV  = d.MaNV)
           OR EXISTS (SELECT 1 FROM dbo.tbl_PhieuNhap   pn  WHERE pn.MaNV  = d.MaNV)
           OR EXISTS (SELECT 1 FROM dbo.tbl_PhieuXuat   px  WHERE px.MaNV  = d.MaNV)
           OR EXISTS (SELECT 1 FROM dbo.tbl_PhieuKiemKe pkk WHERE pkk.MaNV = d.MaNV)
    )
    BEGIN
        RAISERROR(
            N'Nhân viên đã lập chứng từ (hóa đơn / phiếu nhập / phiếu xuất / kiểm kê), không được phép xóa. Nên chuyển trạng thái ngưng làm việc.',
            16, 1
        );
        ROLLBACK TRANSACTION;
        RETURN;
    END;

    -- Các nhân viên chưa dùng ở đâu → cho phép xóa
    DELETE nv
    FROM dbo.tbl_NhanVien nv
    JOIN deleted d ON nv.MaNV = d.MaNV;
END;
GO

--Quản lý không muốn khi nhân viên nghỉ làm thì bị xóa mất khỏi bảng tbl_NhanVien, vì:

--Hóa đơn, phiếu nhập, phiếu kiểm kê cũ vẫn phải thể hiện đúng người lập.

--Thử xóa 1 nhân viên có lập hóa đơn, ví dụ NV010:
DELETE FROM dbo.tbl_NhanVien
WHERE MaNV = 'NV010';

--TRG_CTHoaDon_CapNhatBangDoanhThuNgay
--Tự động cập nhật bảng báo cáo doanh thu theo ngày mỗi khi có thay đổi chi tiết hóa đơn.

--Bảng tóm tắt doanh thu ngày
IF OBJECT_ID('dbo.tbl_DoanhThuNgay', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.tbl_DoanhThuNgay
    (
        NgayBan        DATE        NOT NULL PRIMARY KEY,
        TongSoHoaDon   INT         NOT NULL,
        TongDoanhThu   DECIMAL(18,2) NOT NULL
    );
END;
GO

--TRigger
USE WINMART;
GO

IF OBJECT_ID('dbo.TRG_CTHoaDon_CapNhatBangDoanhThuNgay', 'TR') IS NOT NULL
    DROP TRIGGER dbo.TRG_CTHoaDon_CapNhatBangDoanhThuNgay;
GO

CREATE TRIGGER dbo.TRG_CTHoaDon_CapNhatBangDoanhThuNgay
ON dbo.tbl_CTHoaDon
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -------------------------------------------------
    -- 1. Xác định các ngày bán bị ảnh hưởng
    -------------------------------------------------
    DECLARE @AffectedNgay TABLE (NgayBan DATE PRIMARY KEY);

    INSERT INTO @AffectedNgay(NgayBan)
    SELECT DISTINCT hd.NgayBan
    FROM dbo.tbl_HoaDon hd
    JOIN (
            SELECT MaHD FROM inserted
            UNION
            SELECT MaHD FROM deleted
         ) AS a
        ON hd.MaHD = a.MaHD;

    -------------------------------------------------
    -- 2. Xóa dữ liệu cũ của những ngày này
    -------------------------------------------------
    DELETE FROM dbo.tbl_DoanhThuNgay
    WHERE NgayBan IN (SELECT NgayBan FROM @AffectedNgay);

    -------------------------------------------------
    -- 3. Tính lại doanh thu cho những ngày đó
    -------------------------------------------------
    INSERT INTO dbo.tbl_DoanhThuNgay (NgayBan, TongSoHoaDon, TongDoanhThu)
    SELECT 
        hd.NgayBan,
        COUNT(DISTINCT hd.MaHD)             AS TongSoHoaDon,
        SUM(ct.SoLuongBan * ct.GiaBan)      AS TongDoanhThu
    FROM dbo.tbl_HoaDon   hd
    JOIN dbo.tbl_CTHoaDon ct ON hd.MaHD = ct.MaHD
    JOIN @AffectedNgay    an ON hd.NgayBan = an.NgayBan
    GROUP BY hd.NgayBan;
END;
GO

--Quản lý muốn xem:
--Doanh thu theo từng ngày


INSERT INTO dbo.tbl_CTHoaDon (MaHD, MaMH, SoLuongBan, GiaBan)
VALUES ('HD001', 'MH002', 2, 7000);

--Trigger sẽ tự chạy, cập nhật tbl_DoanhThuNgay cho ngày bán của HD001

SELECT * 
FROM dbo.tbl_DoanhThuNgay
ORDER BY NgayBan;

--Trigger LOG THAY ĐỔI GIÁ BÁN – quản lý kiểm soát giá
--Mỗi lần quản lý chỉnh giá bán sản phẩm → hệ thống tự ghi lại:
--Mã hàng, tên hàng, giá cũ, giá mới, thời điểm, người thay đổi.
--Giúp kiểm soát: ai đổi giá, đổi khi nào

--Tạo bảng log giá
USE WINMART;
GO

IF OBJECT_ID('dbo.tbl_LogGiaMatHang', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.tbl_LogGiaMatHang
    (
        LogID        INT IDENTITY(1,1) PRIMARY KEY,
        MaMH         VARCHAR(10),
        TenMH        NVARCHAR(100),
        GiaCu        INT,
        GiaMoi       INT,
        ThoiGianLog  DATETIME      NOT NULL DEFAULT GETDATE(),
        UserThayDoi  SYSNAME       NULL,
        GhiChu       NVARCHAR(200) NULL
    );
END;
GO

--Trigger log thay đổi giá
IF OBJECT_ID('dbo.TRG_MatHang_LogThayDoiGia', 'TR') IS NOT NULL
    DROP TRIGGER dbo.TRG_MatHang_LogThayDoiGia;
GO

CREATE TRIGGER dbo.TRG_MatHang_LogThayDoiGia
ON dbo.tbl_MatHang
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Chỉ log khi GiaBan thay đổi
    INSERT INTO dbo.tbl_LogGiaMatHang
        (MaMH, TenMH, GiaCu, GiaMoi, UserThayDoi, GhiChu)
    SELECT 
        d.MaMH,
        d.TenMH,
        d.GiaBan      AS GiaCu,
        i.GiaBan      AS GiaMoi,
        SUSER_SNAME() AS UserThayDoi,
        N'Trigger log thay đổi giá bán do quản lý chỉnh sửa.'
    FROM deleted d
    JOIN inserted i 
         ON d.MaMH = i.MaMH
    WHERE ISNULL(d.GiaBan,0) <> ISNULL(i.GiaBan,0);
END;
GO
--đây là trigger phục vụ công tác quản trị giá, giúp kiểm soát rủi ro chỉnh giá sai / cố ý.
        

-- B1: Xem giá hiện tại
SELECT MaMH, TenMH, GiaBan
FROM dbo.tbl_MatHang
WHERE MaMH = 'MH001';

-- Giả sử đang là 35000.
-- B2: Đổi tạm về 32000 (lúc này trigger sẽ log 1 lần)
UPDATE dbo.tbl_MatHang
SET GiaBan = 32000
WHERE MaMH = 'MH001';

-- B3: Đổi từ 32.000 lên 35.000 (trigger log thêm lần nữa)
UPDATE dbo.tbl_MatHang
SET GiaBan = 40000
WHERE MaMH = 'MH001';

-- B4: Xem bảng log
SELECT *
FROM dbo.tbl_LogGiaMatHang
ORDER BY LogID DESC;

--Trigger XẾP HẠNG KHÁCH HÀNG TỰ ĐỘNG (Đồng – Bạc – Vàng)
--Trigger này kết hợp với tbl_KhachHang_TongChiTieu mà bạn đã dùng cho thu ngân:
-- Thu ngân bán hàng → trigger thu ngân cập nhật tổng chi tiêu
--Quản lý: muốn biết khách nào là thân thiết / VIP → trigger này tự xếp hạng.

--Thêm cột hạng trong bảng tổng chi tiêu
USE WINMART;
GO

IF COL_LENGTH('dbo.tbl_KhachHang_TongChiTieu', 'HangMuc') IS NULL
BEGIN
    ALTER TABLE dbo.tbl_KhachHang_TongChiTieu
    ADD HangMuc NVARCHAR(20) NULL;   -- 'Đồng', 'Bạc', 'Vàng', ...
END;
GO

IF OBJECT_ID('dbo.TRG_TongChiTieu_XepHangKhachHang', 'TR') IS NOT NULL
    DROP TRIGGER dbo.TRG_TongChiTieu_XepHangKhachHang;
GO

CREATE TRIGGER dbo.TRG_TongChiTieu_XepHangKhachHang
ON dbo.tbl_KhachHang_TongChiTieu
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE t
    SET HangMuc = CASE 
                      WHEN t.TongTienDaMua >= 500000  THEN N'Vàng'
                      WHEN t.TongTienDaMua >= 100000  THEN N'Bạc'
                      ELSE N'Đồng'
                  END
    FROM dbo.tbl_KhachHang_TongChiTieu t
    JOIN inserted i ON t.MaKH = i.MaKH;
END;
GO

--Gán hạng cho các khách đã có dữ liệu từ trước
UPDATE t
SET HangMuc = CASE 
                  WHEN t.TongTienDaMua >= 500000  THEN N'Vàng'
                  WHEN t.TongTienDaMua >= 100000  THEN N'Bạc'
                  ELSE N'Đồng'
              END
FROM dbo.tbl_KhachHang_TongChiTieu t;


SELECT *
FROM dbo.tbl_KhachHang_TongChiTieu
WHERE MaKH = 'KH005';

SELECT 
    hd.MaHD,
    hd.NgayBan,
    kh.HoTenKH,
    kh.DienThoai,
    hd.GhiChu
FROM HoaDon hd
JOIN KhachHang kh ON hd.MaKH = kh.MaKH
WHERE hd.MaHD = 'HD001';

SELECT 
    lh.TenLH,
    SUM(mh.SoLuongTon * mh.GiaBan) AS TongGiaTriTon
FROM MatHang mh
JOIN LoaiHang lh ON mh.MaLH = lh.MaLH
GROUP BY lh.TenLH
ORDER BY TongGiaTriTon DESC;


--Kiểm thử phân quyền Nhân viên thu ngân 
EXECUTE AS USER = 'WinmartCashierUser';
DELETE FROM dbo.tbl_HoaDon WHERE MaHD = 'HD001';   -- Không được phép xóa hóa đơn
REVERT;
--Kiểm thử phân quyền Nhân viên thủ kho 

EXECUTE AS USER = 'WinmartWarehouseUser';
DELETE FROM dbo.tbl_CTPhieuXuat WHERE MaPX = 'PX001';
REVERT;


--FUNCTION  – Kiểm tra tồn kho hiện tại của mặt hàng
CREATE FUNCTION fn_TonKho_MatHang(@MaMH VARCHAR(20))
RETURNS INT
AS
BEGIN
    RETURN (SELECT ISNULL(SoLuongTon,0)
            FROM dbo.tbl_MatHang 
            WHERE MaMH = @MaMH);
END;
GO

SELECT dbo.fn_TonKho_MatHang('MH001') AS TonKho;

--FUNCTION  – Tính tổng giá trị hàng nhập trong một ngày
CREATE FUNCTION fn_TongGiaTriNhap_TheoNgay(@Ngay DATE)
RETURNS DECIMAL(18,2)
AS
BEGIN
    RETURN (
        SELECT ISNULL(SUM(SoLuongNhap * GiaNhap), 0)
        FROM dbo.tbl_CTPhieuNhap ct
        JOIN dbo.tbl_PhieuNhap pn ON ct.MaPN = pn.MaPN
        WHERE CAST(pn.NgayNhap AS DATE) = @Ngay
    );
END;
GO

SELECT dbo.fn_TongGiaTriNhap_TheoNgay('2023-04-04') AS TongGiaTriNhap;

--FUNCTION – Lợi nhuận mặt hàng theo khoảng ngày 
CREATE FUNCTION fn_LoiNhuanMatHang_TheoKhoangNgay
(
    @MaMH VARCHAR(10),
    @FromDate DATE,
    @ToDate DATE
)
RETURNS DECIMAL(18,2)
AS
BEGIN
    DECLARE @DoanhThu DECIMAL(18,2),
            @SoLuongBan INT,
            @GiaNhapTB DECIMAL(18,2),
            @GiaVon DECIMAL(18,2);

    -- Tổng SL bán & doanh thu
    SELECT 
        @SoLuongBan = SUM(ct.SoLuongBan),
        @DoanhThu = SUM(ct.SoLuongBan * ct.GiaBan)
    FROM dbo.tbl_CTHoaDon ct
    JOIN dbo.tbl_HoaDon hd ON ct.MaHD = hd.MaHD
    WHERE ct.MaMH = @MaMH
      AND hd.NgayBan BETWEEN @FromDate AND @ToDate;

    IF @SoLuongBan IS NULL
        RETURN 0;

    -- Giá nhập trung bình
    SELECT @GiaNhapTB = AVG(ctn.GiaNhap)
    FROM dbo.tbl_CTPhieuNhap ctn
    WHERE ctn.MaMH = @MaMH;

    SET @GiaVon = @SoLuongBan * @GiaNhapTB;

    RETURN @DoanhThu - @GiaVon;
END;
GO

SELECT dbo.fn_LoiNhuanMatHang_TheoKhoangNgay('MH001', '2024-12-01', '2024-12-31') AS LoiNhuan;

--FUNCTION – Kiểm tra tồn kho thực tế theo mặt hàng 
CREATE FUNCTION fn_TonKhoThucTe_MatHang(@MaMH VARCHAR(10))
RETURNS INT
AS
BEGIN
    DECLARE @Nhap INT, @Xuat INT, @Ban INT;

    -- Tổng nhập
    SELECT @Nhap = ISNULL(SUM(SoLuongNhap), 0)
    FROM dbo.tbl_CTPhieuNhap
    WHERE MaMH = @MaMH;

    -- Tổng xuất
    SELECT @Xuat = ISNULL(SUM(SoLuongXuat), 0)
    FROM dbo.tbl_CTPhieuXuat
    WHERE MaMH = @MaMH;

    -- Tổng bán
    SELECT @Ban = ISNULL(SUM(SoLuongBan), 0)
    FROM dbo.tbl_CTHoaDon
    WHERE MaMH = @MaMH;

    RETURN (@Nhap - @Xuat - @Ban);
END;
GO


SELECT dbo.fn_TonKhoThucTe_MatHang('MH009') AS TonThucTe;

-- transaction
--Transaction – Giảm tồn kho khi bán hàng (mức cô lập READ COMMITTED)
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
BEGIN TRANSACTION;

DECLARE @SoLuongTon INT;

SELECT @SoLuongTon = SoLuongTon
FROM dbo.tbl_MatHang WITH (ROWLOCK, HOLDLOCK)
WHERE MaMH = 'MH001';

IF (@SoLuongTon < 2)
BEGIN
    PRINT N'Hàng không đủ bán, rollback giao dịch';
    ROLLBACK TRANSACTION;
    RETURN;
END;

UPDATE dbo.tbl_MatHang
SET SoLuongTon = SoLuongTon - 2
WHERE MaMH = 'MH001';

COMMIT TRANSACTION;
PRINT N'Giảm tồn kho thành công (Thu ngân bán hàng)';


--- kiểm tra tồn kho trước khi cập nhật giảm tồn kho 
SELECT MaMH, SoLuongTon 
FROM dbo.tbl_MatHang 
WHERE MaMH = 'MH001';

-- Kiểm tra lại tồn kho sau giao dịch:
SELECT MaMH, SoLuongTon 
FROM dbo.tbl_MatHang 
WHERE MaMH = 'MH001';
---Minh hoạ cơ chế khoá
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
BEGIN TRANSACTION;

UPDATE dbo.tbl_MatHang
SET SoLuongTon = SoLuongTon - 2
WHERE MaMH = 'MH001';

WAITFOR DELAY '00:00:10';

COMMIT TRANSACTION;
PRINT N'Giao dịch bán hàng kết thúc, đã commit thay đổi tồn kho';

---Transaction – Nhập hàng vào kho (mức cô lập SERIALIZABLE)
INSERT INTO dbo.tbl_PhieuNhap(MaPN, NgayNhap, GhiChu, MaNV)
VALUES ('PN_TEST_LOCK', GETDATE(), N'Phiếu nhập test phục vụ kiểm thử khóa', 'NV001');

SELECT MaMH, SoLuongTon
FROM dbo.tbl_MatHang
WHERE MaMH = 'MH010';

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
BEGIN TRANSACTION;

-- Ghi chi tiết phiếu nhập
INSERT INTO dbo.tbl_CTPhieuNhap(MaPN, MaMH, SoLuongNhap, GiaNhap)
VALUES ('PN_TEST_LOCK', 'MH010', 20, 15000);

-- Cập nhật tồn kho mặt hàng
UPDATE dbo.tbl_MatHang
SET SoLuongTon = SoLuongTon + 20
WHERE MaMH = 'MH010';

COMMIT TRANSACTION;
PRINT N'Nhập hàng thành công (Thủ kho nhập kho)';

SELECT MaMH, SoLuongTon
FROM dbo.tbl_MatHang
WHERE MaMH = 'MH010';


--Minh hoạ cơ chế khoá
USE WINMART;
GO
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
BEGIN TRANSACTION;
UPDATE dbo.tbl_MatHang
SET SoLuongTon = SoLuongTon + 40
WHERE MaMH = 'MH010';

-- Giữ khóa 10 giây để kiểm thử
WAITFOR DELAY '00:00:10';
COMMIT TRANSACTION;
PRINT N'Nhập hàng thành công (Thủ kho nhập kho)';


