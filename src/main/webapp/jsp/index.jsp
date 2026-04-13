<%--
  Created by IntelliJ IDEA.
  User: a2157
  Date: 2025/12/16
  Time: 16:56
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path;

    // 展品展示的标识，判断是哪个页面用的
    String categoryIdParam = request.getParameter("categoryId") != null ? request.getParameter("categoryId") : "1";
    String mode = request.getParameter("mode") != null ? request.getParameter("mode") : "display";

    // 展品的各种属性
    String editExhibitCode = request.getParameter("editExhibitCode");
    String editExhibitName = request.getParameter("editExhibitName");
    String editDescription = request.getParameter("editDescription");
    String editExhibitId = request.getParameter("editExhibitId");
    String editImagePath = request.getParameter("editImagePath");
    
    // 判断是不是编辑页面
    boolean isEditMode = editExhibitId != null && !editExhibitId.isEmpty();
%>
<html>
<head>
    <title>山河破晓：抗战岁月的记忆与传承</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        /*加载字体的*/
        @import url('https://fonts.googleapis.com/css2?family=Noto+Serif+SC:wght@400;700;900&family=Ma+Shan+Zheng&family=ZCOOL+QingKe+HuangYou&display=swap');

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Noto Serif SC', serif;
            color: #3a2c2c;
            min-height: 100vh;
            background: linear-gradient(rgba(0,0,0,0.6), rgba(0,0,0,0.6)),
            url('<%=basePath%>/images/index/bg.png');
            background-size: cover;
            background-position: center;
            background-attachment: fixed;
            line-height: 1.8;
        }

        .header {
            background: linear-gradient(rgba(139, 0, 0, 0.8), rgba(178, 34, 34, 0.8)),
            url('../images/top3.png') center/100% 100% no-repeat;
            color: white;
            text-align: center;
            padding: 20px 0;
            box-shadow: 0 2px 10px rgba(0,0,0,0.3);
            position: fixed;
            top: 0;
            width: 100%;
            z-index: 1000;
        }

        .header h1 {
            font-family: 'Ma Shan Zheng', cursive;
            font-size: 2.2em;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.5);
            letter-spacing: 1px;
        }

        /* 底部导航 - 修改为居中布局 */
        .footer-nav {
            background: #940808;
            color: white;
            padding: 10px 15px;
            position: fixed;
            bottom: 0;
            width: 100%;
            display: flex;
            justify-content: center;
            align-items: center;
            z-index: 1000;
            border-top: 2px solid #d4af37;
            overflow-x: auto;
            scrollbar-width: none;
            -ms-overflow-style: none;
        }

        .footer-nav::-webkit-scrollbar {
            display: none;
        }

        .nav-items-container {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 20px;
            flex-wrap: nowrap;
            margin: 0 auto;
        }

        /* 统一导航按钮的样式 */
        .nav-item {
            display: flex;
            flex-direction: column;
            align-items: center;
            cursor: pointer;
            transition: all 0.3s ease;
            min-width: 70px;
            padding: 5px 8px;
            border-radius: 5px;
            flex-shrink: 0;
            border: 2px solid transparent;
            box-sizing: border-box;
        }

        .nav-item:hover {
            background: rgba(255, 255, 255, 0.1);
            transform: translateY(-3px);
            border: 2px solid rgba(255, 255, 255, 0.1);
        }

        .nav-item.active {
            background: rgba(255, 255, 255, 0.15);
            border: 2px solid rgba(212, 175, 55, 0.5);
            border-bottom: 2px solid #d4af37;
            padding: 5px 8px;
        }

        .nav-icon {
            width: 36px;
            height: 36px;
            background-size: contain;
            background-repeat: no-repeat;
            background-position: center;
            margin-bottom: 5px;
            border-radius: 5px;
            border: 2px solid rgba(255, 255, 255, 0.3);
            transition: all 0.3s ease;
        }

        .nav-item:hover .nav-icon {
            border-color: #d4af37;
            transform: scale(1.1);
        }

        .nav-text {
            font-family: 'ZCOOL QingKe HuangYou', sans-serif;
            font-size: 0.85em;
            color: #fff8e1;
            text-align: center;
            line-height: 1.2;
            max-width: 80px;
            word-break: break-word;
        }

        .category-nav-item {
            min-width: 70px;
        }

        .category-nav-icon {
            width: 36px;
            height: 36px;
            object-fit: cover;
            border-radius: 5px;
            border: 2px solid rgba(255, 255, 255, 0.3);
            transition: all 0.3s ease;
        }

        .nav-item:hover .category-nav-icon {
            border-color: #d4af37;
            transform: scale(1.1);
            filter: grayscale(0%) brightness(100%);
        }

        /* 主内容区域 */
        .main-content {
            min-height: calc(100vh - 140px);
            padding: 100px 20px 80px;
            max-width: 1400px;
            margin: 0 auto;
            position: relative;
            overflow: hidden;
        }

        /* 页面切换动画 */
        .page-container {
            position: relative;
            min-height: 500px;
        }

        .page {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            opacity: 0;
            transform: translateX(30px);
            transition: all 0.5s cubic-bezier(0.4, 0, 0.2, 1);
            pointer-events: none;
        }

        .page.active {
            opacity: 1;
            transform: translateX(0);
            pointer-events: all;
        }

        .page.slide-out-left {
            transform: translateX(-30px);
            opacity: 0;
        }

        .page.slide-out-right {
            transform: translateX(30px);
            opacity: 0;
        }

        /* 首页的样式  */
        .home-page {
            background: rgba(253, 248, 234, 0.95);
            padding: 45px 40px;
            border-radius: 2px;
            box-shadow: 0 5px 25px rgba(0,0,0,0.4);
            line-height: 2;
            font-size: 1.15em;
            text-align: justify;
            text-indent: 2.5em;
            border: 1px solid #d4af37;
            position: relative;
        }

        .home-page h2 {
            font-family: 'ZCOOL QingKe HuangYou', sans-serif;
            color: #5d1919;
            text-align: center;
            margin-bottom: 35px;
            font-size: 2.1em;
            font-weight: 400;
            padding: 15px 0;
            position: relative;
            text-transform: uppercase;
            letter-spacing: 3px;
        }

        .home-page h2::before,
        .home-page h2::after {
            content: "—";
            color: #8b0000;
            margin: 0 15px;
            font-size: 1.5em;
        }

        /*  分类管理的样式 */
        .category-table {
            background: white;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            overflow: hidden;
        }

        .category-table tbody tr {
            transition: all 0.3s ease;
            cursor: pointer;
        }

        .category-table tbody tr:hover {
            background: linear-gradient(135deg, #fff9f9, #fff5f5);
            transform: translateX(5px);
            box-shadow: 0 4px 12px rgba(139, 0, 0, 0.1);
        }

        .category-table tbody tr:hover td {
            color: #8B0000;
            border-bottom-color: #ffcccc;
        }

        /* 添加动画效果 */
        .category-table tbody tr {
            animation: fadeInUp 0.5s ease forwards;
            opacity: 0;
            transform: translateY(10px);
        }

        @keyframes fadeInUp {
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* 表单的样式 */
        .add-category-form {
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            margin-bottom: 30px;
            animation: fadeIn 0.5s ease;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .form-horizontal {
            display: flex;
            flex-wrap: wrap;
            align-items: flex-end;
            gap: 20px;
        }

        .form-horizontal .form-group {
            flex: 1;
            min-width: 150px;
            margin-bottom: 0;
        }

        .form-horizontal .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: #940808;
            font-size: 14px;
        }

        .form-horizontal .form-group input {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 1em;
        }

        .form-horizontal .form-group input:focus {
            outline: none;
            border-color: #8B0000;
            box-shadow: 0 0 0 2px rgba(139, 0, 0, 0.2);
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }

        th {
            background: #960A0A;
            color: white;
            font-weight: bold;
        }

        /* 操作按钮 */
        .action-buttons {
            display: flex;
            gap: 5px;
        }

        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 1em;
            transition: all 0.3s ease;
            font-weight: bold;
        }

        .btn-primary {
            background: #8B0000;
            color: white;
        }

        .btn-secondary {
            background: #6c757d;
            color: white;
        }

        .btn-info {
            background: #3498db;
            color: white;
        }

        .btn-warning {
            background: #f39c12;
            color: white;
        }

        .btn-danger {
            background: #e74c3c;
            color: white;
        }

        .btn-sm {
            padding: 5px 10px;
            font-size: 0.9em;
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
        }

        /* 分类图标 这个在动态添加中使用*/
        .category-icon {
            width: 50px;
            height: 50px;
            object-fit: cover;
            border-radius: 5px;
            transition: all 0.3s ease;
        }

        .category-table tbody tr:hover .category-icon {
            transform: scale(1.1);
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
        }

        /* 消息区域 */
        .message-area {
            padding: 15px;
            background: white;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            margin-top: 20px;
            margin-bottom: 20px;
            animation: slideInUp 0.5s ease;
        }

        @keyframes slideInUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* 展品展示的样式  */
        /* 展品切换动画 */
        .exhibit-display {
            background: white;
            border-radius: 15px;
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
            overflow: hidden;
            position: relative;
            min-height: 600px;
        }

        .exhibit-content {
            display: flex;
            min-height: 500px;
            opacity: 1;
            transition: all 0.5s ease;
        }

        .exhibit-content.slide-out-left {
            transform: translateX(-100%);
            opacity: 0;
        }

        .exhibit-content.slide-out-right {
            transform: translateX(100%);
            opacity: 0;
        }

        .exhibit-content.slide-in-left {
            animation: slideInLeft 0.5s ease forwards;
        }

        .exhibit-content.slide-in-right {
            animation: slideInRight 0.5s ease forwards;
        }

        @keyframes slideInLeft {
            from {
                transform: translateX(100%);
                opacity: 0;
            }
            to {
                transform: translateX(0);
                opacity: 1;
            }
        }

        @keyframes slideInRight {
            from {
                transform: translateX(-100%);
                opacity: 0;
            }
            to {
                transform: translateX(0);
                opacity: 1;
            }
        }

        /* 分类标题 */
        .category-title {
            background: #960A0A;
            color: white;
            text-align: center;
            padding: 15px;
            font-family: 'Ma Shan Zheng', cursive;
            font-size: 2em;
            margin-bottom: 20px;
            border-radius: 10px;
            animation: fadeInDown 0.5s ease;
        }

        @keyframes fadeInDown {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .exhibit-image {
            flex: 1;
            background: #f8f9fa;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 30px;
            transition: all 0.3s ease;
        }

        .exhibit-image img {
            max-width: 100%;
            max-height: 400px;
            object-fit: contain;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
            transition: all 0.3s ease;
        }

        .exhibit-image:hover img {
            transform: scale(1.02);
            box-shadow: 0 6px 20px rgba(0,0,0,0.3);
        }

        .exhibit-info {
            flex: 1;
            padding: 40px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .exhibit-name {
            font-size: 2em;
            color: #8B0000;
            margin-bottom: 20px;
            border-bottom: 2px solid #eee;
            padding-bottom: 10px;
            animation: textGlow 2s infinite alternate;
        }

        @keyframes textGlow {
            from {
                text-shadow: 0 0 10px rgba(139, 0, 0, 0.3);
            }
            to {
                text-shadow: 0 0 20px rgba(139, 0, 0, 0.5);
            }
        }

        .exhibit-description {
            line-height: 1.8;
            font-size: 1.1em;
            color: #555;
            max-height: 300px;
            overflow-y: auto;
            animation: fadeIn 1s ease;
        }

        /* 导航按钮 */
        .navigation-buttons {
            display: flex;
            justify-content: space-between;
            padding: 20px;
            background: #f8f9fa;
        }

        .nav-arrow {
            color: white;
            border: none;
            padding: 15px 25px;
            border-radius: 50px;
            cursor: pointer;
            font-size: 1.1em;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
            background-size: auto 250%; /* 保持高度放大 */
            background-position: center center;
            background-repeat: no-repeat;
            text-shadow: 1px 1px 2px rgba(0,0,0,0.5);
            margin: 0 10px;
            background-image: linear-gradient(rgba(0, 0, 0, 0.4), rgba(0, 0, 0, 0.4));
        }

        .nav-arrow:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(139, 0, 0, 0.4);
            background-image: linear-gradient(rgba(0, 0, 0, 0.2), rgba(0, 0, 0, 0.2));
        }
        .nav-arrow:active {
            transform: translateY(-1px);
        }

        .nav-arrow::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            width: 5px;
            height: 5px;
            background: rgba(255, 255, 255, 0.5);
            opacity: 0;
            border-radius: 100%;
            transform: scale(1, 1) translate(-50%);
            transform-origin: 50% 50%;
        }

        .nav-arrow:focus:not(:active)::before {
            animation: ripple 1s ease-out;
        }

        @keyframes ripple {
            0% {
                transform: scale(0, 0);
                opacity: 0.5;
            }
            100% {
                transform: scale(20, 20);
                opacity: 0;
            }
        }

        .action-buttons-exhibit {
            display: flex;
            gap: 10px;
            justify-content: center;
            padding: 20px;
            background: #f8f9fa;
            border-top: 1px solid #eee;
        }

        .btn-success {
            background: #27ae60;
            color: white;
        }

        #displayExhibitDescription a {
            color: red !important;
            text-decoration: none;
        }

        #displayExhibitDescription a:hover {
            color: #cc0000 !important;
            text-decoration: underline;
        }

        #displayExhibitDescription a:visited {
            color: #990000 !important;
        }

        .exhibit-counter {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 20px;
            padding: 10px 20px;
            margin: 10px 0;
            background: #f5f5f5;
            border-radius: 5px;
            font-size: 1em;
        }

        .exhibit-counter span {
            color: #8B0000;
            font-weight: bold;
            margin-left: 5px;
        }

        /* 添加/编辑展品的表单样式 */
        .add-exhibit-form {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
            max-width: 800px;
            margin: 0 auto;
            animation: slideInUp 0.5s ease;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
            color: #940808;
        }

        .form-group input,
        .form-group textarea {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 1em;
            font-family: "Microsoft YaHei", sans-serif;
            transition: all 0.3s ease;
        }

        .form-group input:focus,
        .form-group textarea:focus {
            border-color: #8B0000;
            box-shadow: 0 0 0 3px rgba(139, 0, 0, 0.1);
            transform: translateY(-2px);
        }

        .form-group textarea {
            height: 150px;
            resize: vertical;
        }

        .current-category {
            background: #e8f4fd;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
            border-left: 4px solid #3498db;
            animation: fadeIn 0.5s ease;
        }

        /* 响应式设计 */
        @media (max-width: 768px) {
            .header h1 {
                font-size: 1.8em;
            }

            .main-content {
                padding: 100px 10px 80px;
            }

            .exhibit-content {
                flex-direction: column;
                min-height: auto;
            }

            .form-horizontal {
                flex-direction: column;
                align-items: stretch;
                gap: 15px;
            }

            .footer-nav {
                gap: 10px;
                padding: 8px 10px;
            }

            .nav-items-container {
                gap: 12px;
            }

            .nav-item {
                min-width: 65px;
                padding: 3px 5px;
            }

            .nav-icon {
                width: 32px;
                height: 32px;
            }

            .category-nav-icon {
                width: 30px;
                height: 30px;
            }

            .nav-text {
                font-size: 0.75em;
                max-width: 65px;
            }
        }
    </style>
</head>
<body>
<div class="header">
    <h1>山河破晓：抗战岁月的记忆与传承</h1>
</div>

<div class="main-content">
    <div class="page-container">
        <!-- 首页 -->
        <div id="home-page" class="page active">
            <div class="home-page">
                <h2>抗日战争历史简介</h2>
                <p>抗日战争是20世纪中华民族为抵抗日本帝国主义侵略而进行的一场伟大的民族解放战争。这场战争始于1937年的七七事变，结束于1945年日本无条件投降，历时八年之久。</p>

                <p>在艰苦卓绝的抗战岁月中，中国人民展现了不屈不挠的民族精神。从正面战场的淞沪会战、太原会战、徐州会战、武汉会战等重要战役，到敌后战场的游击战争；从国共两党的合作抗日，到全国各族人民的共同参与，形成了全民族抗战的壮丽画卷。</p>

                <p>在这场战争中，涌现出了无数可歌可泣的英雄人物和感人事迹。有在战场上浴血奋战的将士，有在敌后坚持斗争的地下工作者，有在国际上奔走呼号争取支持的外交人士，更有千千万万默默奉献的普通民众。</p>

                <p>抗日战争的胜利，是近代以来中国抗击外敌入侵的第一次完全胜利，洗刷了百年民族耻辱，重新确立了中国在世界上的大国地位，开辟了中华民族伟大复兴的光明前景。</p>

                <p>今天，我们回顾这段历史，不仅要铭记先烈们的丰功伟绩，更要传承伟大的抗战精神，为实现中华民族的伟大复兴而努力奋斗。</p>
                <div style="text-align: center; margin-top: 20px; padding-top: 20px; border-top: 1px solid #1E1F22;">
                    <p>江西财经大学 ◆ 软件与物联网工程学院 ◆ Web服务与RESTful技术 ◆ 大作业演示项目<br>
                        组长：刘圣杰  组员1：吴星乐  组员2：吴子超  组员3：曾森海</p>
                </div>
            </div>
        </div>

        <!-- 分类管理页面 -->
        <div id="category-page" class="page">
            <!-- 添加分类表单 -->
            <div class="add-category-form">
                <h2 id="formTitle">添加新分类</h2>
                <div class="form-horizontal">
                    <div class="form-group">
                        <label for="id">ID</label>
                        <input type="text" id="id" placeholder="自动生成" readonly>
                    </div>
                    <div class="form-group">
                        <label for="categoryCode">分类编号</label>
                        <input type="text" id="categoryCode" placeholder="请输入分类编号">
                    </div>
                    <div class="form-group">
                        <label for="categoryName">分类标题</label>
                        <input type="text" id="categoryName" placeholder="请输入分类标题">
                    </div>
                    <input type="hidden" id="iconPath">
                    <div class="form-buttons">
                        <button class="btn btn-primary" id="addCategoryBtn" onclick="categoryAdd()">添加分类</button>
                        <button class="btn btn-primary" id="updateCategoryBtn" onclick="updateCategory()" style="display: none;">更新分类</button>
                        <button class="btn btn-secondary" id="cancelEditBtn" style="display: none;">取消编辑</button>
                    </div>
                </div>
            </div>

            <!-- 分类列表 -->
            <div class="category-table">
                <h2 style="padding: 20px; margin: 0; color: #940808;">分类列表</h2>
                <table>
                    <thead>
                    <tr>
                        <th>id</th>
                        <th>分类图标</th>
                        <th>分类编号</th>
                        <th>分类标题</th>
                        <th>操作</th>
                    </tr>
                    </thead>
                    <tbody id="categoryTableBody">
                        <!-- 分类数据将通过是动态加载加载部分 -->
                    </tbody>
                </table>
            </div>

            <!-- 服务器反馈信息 -->
            <div class="message-area">
                <strong>服务器反馈信息：</strong><span id="message"></span>
            </div>
        </div>

        <!-- 展品展示页面 -->
        <div id="exhibit-page" class="page">
            <!-- 分类标题 -->
            <div class="category-title" id="categoryTitle">
                展品展示
            </div>

            <!-- 展品展示界面 -->
            <div class="exhibit-display" id="exhibit-display-section">
                <div class="exhibit-content" id="exhibit-content">
                    <div class="exhibit-image">
                        <img id="exhibitImage" src="<%=basePath%>/images/default-exhibit.jpg" alt="展品图片">
                    </div>
                    <div class="exhibit-info">
                        <h2 class="exhibit-name" id="displayExhibitName">展品名称</h2>
                        <div class="exhibit-description" id="displayExhibitDescription">
                            展品描述信息将在这里显示...
                        </div>
                    </div>
                </div>

                <div class="exhibit-counter" id="exhibitCounter">
                    展品ID: <span id="currentExhibitId">0</span> |
                    编号: <span id="currentExhibitCode">000000</span> |
                    位置: <span id="currentIndex">1</span>/<span id="totalCount">0</span>
                </div>

                <div class="navigation-buttons">
                    <button class="nav-arrow" onclick="previousExhibitWithAnimation()"
                            style="background-image: url('../images/prev.png'); width: 100px; height: 50px"></button>
                    <button class="nav-arrow" onclick="nextExhibitWithAnimation()"
                            style="background-image: url('../images/next.png'); width: 100px; height: 50px"></button>
                </div>

                <div class="action-buttons-exhibit">
                    <button class="btn btn-success" onclick="switchToAddMode()">添加展品</button>
                    <button class="btn btn-info" onclick="uploadImageForCurrentExhibit()">上传图片</button>
                    <button class="btn btn-warning" onclick="editCurrentExhibit()">编辑当前展品</button>
                    <button class="btn btn-danger" onclick="deleteCurrentExhibit()">删除当前展品</button>
                </div>
            </div>

            <!-- 添加/编辑展品界面 -->
            <div class="add-exhibit-form" id="add-exhibit-section" style="display: none;">
                <h2 class="page-title" id="exhibitFormTitle">
                    添加新展品
                </h2>

                <!-- 当前分类信息 -->
                <div class="current-category">
                    <strong>所属分类：</strong>
                    <span id="currentCategoryName">正在加载...</span>
                </div>

                <input type="hidden" id="imagePath" value="<%= editImagePath != null ? editImagePath : "" %>">

                <!-- 展品表单 -->
                <div class="form-group">
                    <label for="addExhibitCode">展品编号 *</label>
                    <input type="text" id="addExhibitCode" placeholder="请输入展品编号" required
                           value="<%= editExhibitCode != null ? editExhibitCode : "" %>">
                </div>

                <div class="form-group">
                    <label for="addExhibitName">展品标题 *</label>
                    <input type="text" id="addExhibitName" placeholder="请输入展品标题" required
                           value="<%= editExhibitName != null ? editExhibitName : "" %>">
                </div>

                <div class="form-group">
                    <label for="addExhibitDescription">展品描述 *</label>
                    <textarea id="addExhibitDescription" placeholder="请输入展品的详细描述..." required><%= editDescription != null ? editDescription : "" %></textarea>
                </div>

                <div class="form-buttons">
                    <button class="btn btn-primary" id="addExhibitBtn" onclick="exhibitAdd()">
                        提交添加
                    </button>
                    <button class="btn btn-primary" id="updateExhibitBtn" onclick="exhibitAdd()" style="display: none;">
                        提交编辑
                    </button>
                    <button class="btn btn-secondary" onclick="switchToDisplayModeWithAnimation()">返回展示</button>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="footer-nav">
    <div class="nav-items-container" id="navItems">
        <!-- 首页的按钮 -->
        <div class="nav-item active" id="nav-home" onclick="toHome()">
            <div class="nav-icon" style="background-image: url('<%=basePath%>/images/index/home.png');"></div>
            <div class="nav-text">首页</div>
        </div>

        <!-- 分类管理的按钮 -->
        <div class="nav-item" id="nav-category" onclick="showCategoryPage()">
            <div class="nav-icon" style="background-image: url('<%=basePath%>/images/index/category.png');"></div>
            <div class="nav-text">分类管理</div>
        </div>

        <%--        <!-- 刷新按钮 -->--%>
        <%--        <div class="nav-item" id="nav-refresh" onclick="refreshData()">--%>
        <%--            <div class="nav-icon" style="background-image: url('<%=basePath%>/images/index/flush.png');"></div>--%>
        <%--            <div class="nav-text">刷新</div>--%>
        <%--        </div>--%>

        <!-- 分类图标将动态添加到这里 -->
    </div>
</div>

<!-- 分类表格行模板，方便直接使用 -->
<template id="categoryTableRow">
    <tr>
        <td prop="id"></td>
        <td prop="icon"></td>
        <td prop="categoryCode"></td>
        <td prop="categoryName"></td>
        <td>
            <div class="action-buttons">
                <button class="btn btn-info btn-sm" prop="btUploadIcon">上传图标</button>
                <button class="btn btn-warning btn-sm" prop="btEdit">编辑</button>
                <button class="btn btn-danger btn-sm" prop="btDelete">删除</button>
            </div>
        </td>
    </tr>
</template>

<!-- 底部导航分类图标模板 -->
<template id="navCategoryItem">
    <div class="nav-item category-nav-item" data-category-id="">
        <img class="category-nav-icon" src="" alt="">
        <div class="nav-text"></div>
    </div>
</template>

<script>
    // 全局变量定义
    let currentPage = 'home';
    let categoryListUrl = "<%=basePath%>/api/categories/list";
    let categoryAddUrl = "<%=basePath%>/api/categories/add";
    let categoryDeleteUrl = "<%=basePath%>/api/categories/delete";
    let categoryUpdateUrl = "<%=basePath%>/api/categories/update";
    let getCategoryInfoUrl = "<%=basePath%>/api/categories/info/";
    let exhibitsByCategoryUrl = "<%=basePath%>/api/exhibits/category/";
    let exhibitAddUrl = "<%=basePath%>/api/exhibits/add";
    let exhibitDeleteUrl = "<%=basePath%>/api/exhibits/delete";
    let exhibitUpdateUrl = "<%=basePath%>/api/exhibits/update";
    let uploadExhibitsImageUrl = "<%=basePath%>/api/exhibits/uploadExhibitImage";
    let uploadCategoriesImageUrl = "<%=basePath%>/api/categories/uploadIcon";

    // 分类管理的相关变量
    let categoryConsole;
    let categoryTableBody;
    let message;
    let isEditMode = false;
    let currentEditId = null;

    // 展品展示的相关变量
    const categoryId = '<%= categoryIdParam %>';
    let currentExhibits = [];
    let currentIndex = 0;
    let currentExhibitMode = '<%= mode %>';
    let isExhibitEditMode = <%= isEditMode %>;
    let isAnimating = false;

    $(document).ready(function () {
        categoryConsole = $("#categoryConsole");
        categoryTableBody = $("#categoryTableBody");
        message = $("#message");

        $("#cancelEditBtn").click(function() {
            cancelEdit();
        });

        // 页面打开立即刷新
        refreshNavBar();

        // 判断是哪个页面，再显示
        checkUrlParams();
    });

    // 刷新导航栏
    function refreshNavBar() {
        // 更新导航栏
        request("post", categoryListUrl, {}, function(response) {
            // console.log("成功了，但是显示失败");
            if (response.code === 200) {
                // 更新底部导航栏
                updateNavBar(response.data);
                showCurrentNavItem();
            } else {
                console.error('刷新导航栏失败:', response.message);
            }
        }, function(error) {
            console.error('刷新导航真的失败了:', error);
        });
    }

    // 立即更新导航栏显示
    function updateNavBar(categories) {
        const navItems = $("#navItems");

        const fixedButtons = navItems.children('.nav-item:not([data-category-id])').detach();
        // 清空容器
        navItems.empty();

        // 重新添加按钮
        fixedButtons.each(function() {
            navItems.append($(this));
        });

        // 添加分类图标
        $(categories).each(function (index, item) {
            let navItem = $($("#navCategoryItem").html());
            navItem.attr('data-category-id', item.id);
            navItem.find('.category-nav-icon').attr('src', '<%=basePath%>/images/' + (item.iconPath || "default-icon.png"));
            navItem.find('.nav-text').text(item.categoryName);

            // 点击跳转到展品展示页面
            navItem.click(function() {
                showExhibitPage(item.id);
            });

            // 把新图标添加到总的那个容器中
            navItems.append(navItem);
        });
    }

    // 高亮当前页面对应的导航项
    function showCurrentNavItem() {
        // 先移除其他active类
        $('.nav-item').removeClass('active');

        // 判断是激活哪个
        if (currentPage === 'home') {
            $('#nav-home').addClass('active');
        } else if (currentPage === 'category') {
            $('#nav-category').addClass('active');
        } else if (currentPage === 'exhibit' && window.currentCategoryId) {
            $(`.nav-item[data-category-id="${window.currentCategoryId}"]`).addClass('active');
        }
    }

    // 检查URL参数判断是展品还是分类，决定显示哪个页面
    function checkUrlParams() {
        const urlParams = new URLSearchParams(window.location.search);
        const pageParam = urlParams.get('page');

        if (pageParam === 'category') {
            showCategoryPage();
        } else if (pageParam === 'exhibit') {
            const categoryId = urlParams.get('categoryId');
            if (categoryId) {
                showExhibitPage(categoryId);
            } else {
                toHome();
            }
        } else {
            toHome();
        }
    }

    // 页面跳转首页函数
    function toHome() {
        if (isAnimating) return;
        isAnimating = true;
        currentPage = 'home';
        updateUrl('home');

        // 更新导航栏状态
        updateNavState('home');

        // 执行切换动画
        animatePageSwitch('home-page', () => {
            isAnimating = false;
        });
    }

    function showCategoryPage() {
        if (isAnimating) return;
        isAnimating = true;
        currentPage = 'category';
        updateUrl('category');

        // 更新导航栏状态
        updateNavState('category');

        // 执行切换动画
        animatePageSwitch('category-page', () => {
            loadDataToCategoryTable(categoryListUrl, refreshCategoryTable, submitFailed);
            isAnimating = false;
        });
    }

    function showExhibitPage(categoryId) {
        if (isAnimating) return;
        isAnimating = true;
        currentPage = 'exhibit';
        updateUrl('exhibit', {categoryId: categoryId});

        // 更新导航栏状态
        updateNavState('category-' + categoryId);

        // 添加一个过渡动画
        animatePageSwitch('exhibit-page', () => {
            if (categoryId) {
                window.currentCategoryId = categoryId;
                loadExhibits();
                loadCategoryInfo();
            }

            // 根据模式显示相应界面
            if (currentExhibitMode === 'add' || isExhibitEditMode) {
                $('#exhibit-display-section').hide();
                $('#add-exhibit-section').show();
                if (isExhibitEditMode) {
                    editExhibitFromParams();
                }
            } else {
                $('#exhibit-display-section').show();
                $('#add-exhibit-section').hide();
            }
            isAnimating = false;
        });
    }

    // 展示页面切换动画
    function animatePageSwitch(targetPageId, callback) {
        const currentPage = $('.page.active');
        const targetPage = $('#' + targetPageId);

        if (currentPage.length === 0) {
            // 没有当前活动页面，直接显示目标页面
            targetPage.addClass('active');
            if (callback) callback();
            return;
        }

        // 先移除所有页面的active类
        $('.page').removeClass('active');

        // 添加的动画
        currentPage.addClass('slide-out-left');

        // 延迟后显示新页面
        setTimeout(() => {
            currentPage.removeClass('active slide-out-left');
            targetPage.addClass('active');

            // 添加进入动画
            setTimeout(() => {
                if (callback) callback();
            }, 100);
        }, 300);
    }

    // 展品切换的动画效果
    function previousExhibitWithAnimation() {
        if (isAnimating || currentExhibits.length === 0) return;
        isAnimating = true;

        // 添加动画
        $('#exhibit-content').addClass('slide-out-right');

        setTimeout(() => {
            // 更新展品索引，取个模防止溢出了
            currentIndex = (currentIndex - 1 + currentExhibits.length) % currentExhibits.length;

            // 移除离开动画，添加进入动画
            $('#exhibit-content').removeClass('slide-out-right').addClass('slide-in-left');
            displayCurrentExhibit();

            setTimeout(() => {
                $('#exhibit-content').removeClass('slide-in-left');
                isAnimating = false;
            }, 500);
        }, 300);
    }

    function nextExhibitWithAnimation() {
        if (isAnimating || currentExhibits.length === 0) return;
        isAnimating = true;

        // 添加离开动画
        $('#exhibit-content').addClass('slide-out-left');

        setTimeout(() => {
            // 更新展品索引
            currentIndex = (currentIndex + 1) % currentExhibits.length;

            // 移除离开动画，添加进入动画
            $('#exhibit-content').removeClass('slide-out-left').addClass('slide-in-right');
            displayCurrentExhibit();

            setTimeout(() => {
                $('#exhibit-content').removeClass('slide-in-right');
                isAnimating = false;
            }, 500);
        }, 300);
    }

    // 切换展示模式
    function switchToDisplayModeWithAnimation() {
        $('#add-exhibit-section').fadeOut(300, function() {
            $('#exhibit-display-section').fadeIn(300);
            // currentIndex = 0;
            loadExhibits();
        });
    }

    // 更新URL
    function updateUrl(page, params = {}) {
        const url = new URL(window.location);
        url.searchParams.set('page', page);

        // 清除其他参数
        for (const [key, value] of Object.entries(params)) {
            url.searchParams.set(key, value);
        }

        // 更新URL（不刷新页面）
        window.history.pushState({page: page}, '', url.toString());
    }

    // 更新导航栏状态
    function updateNavState(activeId) {
        // 移除所有active类
        $('.nav-item').removeClass('active');

        // 根据ID添加active类
        if (activeId === 'home') {
            $('#nav-home').addClass('active');
        } else if (activeId === 'category') {
            $('#nav-category').addClass('active');
        } else if (activeId.startsWith('category-')) {
            const categoryId = activeId.split('-')[1];
            $(`.nav-item[data-category-id="${categoryId}"]`).addClass('active');
        }
    }

    //  分类管理功能部分
    let loadDataToCategoryTable = function (url, success, fail) {
        categoryTableBody.empty();
        request("post", url, {}, success, fail, true);
    }

    let refreshCategoryTable = function (response) {
        message.html(response.description);

        // 清空表格并添加新数据
        categoryTableBody.empty();

        $(response.data).each(function (index, item) {
            let tr = $($("#categoryTableRow").html());
            tr.find("[prop='id']").html(item.id);
            tr.find("[prop='categoryCode']").html(item.categoryCode);
            tr.find("[prop='categoryName']").html(item.categoryName);

            // 显示图标
            let img = $("<img>");
            img.attr("height", 48);
            img.attr("src", "<%=basePath%>/images/" + (item.iconPath || "default-icon.png"));
            img.addClass("category-icon");
            tr.find("[prop='icon']").append(img);

            // 按钮绑定事件
            tr.find("[prop='btUploadIcon']").click(function () {
                uploadIcon(item.categoryCode);
            });
            tr.find("[prop='btEdit']").click(function () {
                editCategory(item.id, item.categoryCode, item.categoryName, item.iconPath);
            });
            tr.find("[prop='btDelete']").click(function () {
                categoryDelete(item);
            });

            // 添加行动画延迟
            tr.css('animation-delay', (index * 0.1) + 's');
            categoryTableBody.append(tr);
        });

        // 刷新底部导航栏
        refreshFooterNav(response.data);
    }

    // 刷新底部导航栏
    let refreshFooterNav = function (categories) {
        const navItems = $("#navItems");

        // 先保留原有的两个固定按钮，首页和分类管理
        const fixedButtons = navItems.children('.nav-item:not([data-category-id])').detach();

        // 清空导航栏
        navItems.empty();

        // 重新添加默认按钮
        fixedButtons.each(function() {
            navItems.append($(this));
        });

        // 再添加分类图标
        $(categories).each(function (index, item) {
            let navItem = $($("#navCategoryItem").html());
            navItem.attr('data-category-id', item.id);
            navItem.find('.category-nav-icon').attr('src', '<%=basePath%>/images/' + (item.iconPath || "default-icon.png"));
            navItem.find('.nav-text').text(item.categoryName);

            // 点击分类图标跳转到展品展示页面
            navItem.click(function() {
                showExhibitPage(item.id);
            });

            // 将分类图标添加到刷新按钮之后
            navItems.append(navItem);
        });
    }

    // 上传图标函数
    let uploadIcon = function (categoryCode) {
        let fileInput = document.createElement('input');
        fileInput.type = 'file';
        fileInput.accept = 'image/jpeg,image/png,image/gif,image/jpg';

        fileInput.onchange = function(e) {
            let file = e.target.files[0];
            if (file) {
                let formData = new FormData();
                formData.append('file', file);
                formData.append('categoryCode', categoryCode);

                message.html("正在上传图标...");

                $.ajax({
                    url: uploadCategoriesImageUrl,
                    type: 'POST',
                    data: formData,
                    processData: false,
                    contentType: false,
                    success: function(response) {
                        if (response.code === 200) {
                            message.html("图标上传成功");
                            loadDataToCategoryTable(categoryListUrl, refreshCategoryTable, submitFailed);
                            refreshNavBar();
                        } else {
                            message.html("上传失败：" + response.message);
                        }
                    },
                    error: function(xhr, status, error) {
                        message.html("上传失败：" + error);
                    }
                });
            }
        };

        fileInput.click();
    }

    let gatherCategoryData = function () {
        let category = {
            id: $("#id").val(),
            categoryCode: $("#categoryCode").val(),
            categoryName: $("#categoryName").val(),
            iconPath: $("#iconPath").val()
        };
        return category;
    }

    let categoryAdd = function () {
        let category = gatherCategoryData();
        submit(categoryAddUrl, category);
    }

    let categoryDelete = function (category) {
        if (confirm('确定要删除分类"' + category.categoryName + '"吗？')) {
            submit(categoryDeleteUrl, category, submitSuccessful, submitFailed);
        }
    }

    let editCategory = function (id, categoryCode, categoryName, iconPath) {
        isEditMode = true;
        currentEditId = id;

        // 回显数据到表单
        $("#id").val(id);
        $("#categoryCode").val(categoryCode);
        $("#categoryName").val(categoryName);
        $("#iconPath").val(iconPath || "");

        // 修改表单标题和按钮
        $("#formTitle").text("编辑分类");
        $("#addCategoryBtn").hide();
        $("#updateCategoryBtn").show();
        $("#cancelEditBtn").show();
        $("#id").prop("disabled", true);

        // 滚动到表单位置
        $('html, body').animate({
            scrollTop: $(".add-category-form").offset().top - 50
        }, 500);
    }

    let updateCategory = function() {
        let category = gatherCategoryData();
        submit(categoryUpdateUrl, category);
    }

    let cancelEdit = function() {
        isEditMode = false;
        currentEditId = null;

        // 恢复表单状态
        $("#formTitle").text("添加新分类");
        $("#id").val("");
        $("#categoryCode").val("");
        $("#categoryName").val("");
        $("#iconPath").val("");
        $("#addCategoryBtn").show();
        $("#updateCategoryBtn").hide();
        $("#cancelEditBtn").hide();
        $("#id").prop("disabled", false);

        // 清除提示信息
        message.html("");
    }

    let submitSuccessful = function (response) {
        loadDataToCategoryTable(categoryListUrl, refreshCategoryTable, submitFailed);
        // 刷新导航栏
        refreshNavBar();

        if (isEditMode) {
            cancelEdit();
        } else {
            $("#id").val('');
            $("#categoryCode").val('');
            $("#categoryName").val('');
            $("#iconPath").val('');
        }
    }

    let submitFailed = function (jqXHR, textStatus) {
        message.html(jqXHR.responseText || '请求失败');
    }

    let submit = function (url, data) {
        message.html("");
        request("post", url, data, submitSuccessful, submitFailed, true);
    }

    // 展品展示功能
    // 从URL参数回显编辑数据
    let editExhibitFromParams = function() {
        const editExhibitCode = '<%= editExhibitCode != null ? editExhibitCode : "" %>';
        const editExhibitName = '<%= editExhibitName != null ? editExhibitName : "" %>';
        const editDescription = '<%= editDescription != null ? editDescription : "" %>';
        const editImagePath = '<%= editImagePath != null ? editImagePath : "" %>';

        if (editExhibitCode && editExhibitName) {
            // 回显数据到添加表单
            $("#addExhibitCode").val(decodeURIComponent(editExhibitCode));
            $("#addExhibitName").val(decodeURIComponent(editExhibitName));
            $("#addExhibitDescription").val(decodeURIComponent(editDescription));

            // 回显图片路径到隐藏字段
            if (editImagePath) {
                $("#imagePath").val(decodeURIComponent(editImagePath));
            }

            // 修改表单标题和按钮
            $("#exhibitFormTitle").text("编辑展品");
            $("#addExhibitBtn").hide();
            $("#updateExhibitBtn").show();
        }
    }

    let loadCategoryInfo = function () {
        request("POST", getCategoryInfoUrl + window.currentCategoryId, {}, function(response) {
            if (response.code === 200) {
                $('#categoryTitle').text(response.data.categoryName);
                $('#currentCategoryName').text(response.data.categoryName);

                // # 修改，修复一个小bug，点击新展品，显示错误
                $('#currentExhibitId').text('000');
                $('#currentExhibitCode').text('000000');
            } else {
                $('#categoryTitle').text('展品展示');
                $('#currentCategoryName').text('分类加载失败');
            }
        }, function(jqXHR) {
            console.error('加载分类信息失败:', jqXHR);
            $('#categoryTitle').text('展品展示');
            $('#currentCategoryName').text('未找到分类');
        });
    }

    let loadExhibits = function () {
        request("POST", exhibitsByCategoryUrl + window.currentCategoryId, {}, function(response) {
            if (response.code === 200) {
                currentExhibits = response.data;
                displayCurrentExhibit();
            } else {
                showNoExhibit();
            }
        }, function() {
            showNoExhibit();
        });
    }

    let displayCurrentExhibit = function () {
        if (currentExhibits.length === 0) {
            showNoExhibit();
            return;
        }

        const exhibit = currentExhibits[currentIndex];
        $('#displayExhibitName').text(exhibit.exhibitName);

        $('#displayExhibitDescription').html(exhibit.description || '');
        // 修正图片路径
        let imagePath = exhibit.imagePath || '<%=basePath%>/images/default-exhibit.jpg';
        if (exhibit.imagePath && !exhibit.imagePath.startsWith('http')) {
            imagePath = '<%=basePath%>/images/' + exhibit.imagePath;
        }
        $('#exhibitImage').attr('src', imagePath);
        $('#currentIndex').text(currentIndex + 1);
        $('#totalCount').text(currentExhibits.length);

        // 防止显示错误
        $('#currentExhibitId').text(exhibit.id || '000');
        $('#currentExhibitCode').text(exhibit.exhibitCode || '000000');
    }

    let showNoExhibit = function () {
        $('#displayExhibitName').text('暂无展品');

        // 添加一点默认字样提示
        $('#displayExhibitDescription').html(
            '当前分类还没有添加任何展品，请点击"添加展品"按钮开始添加。<br>'
        );
        $('#exhibitImage').attr('src', '<%=basePath%>/images/default-exhibit.jpg');

        $('#currentIndex').text('0');
        $('#totalCount').text('0');
    }

    // 跳转上一个
    let previousExhibit = function () {
        if (currentExhibits.length === 0) return;
        currentIndex = (currentIndex - 1 + currentExhibits.length) % currentExhibits.length;
        displayCurrentExhibit();
    }

    // 跳转下一个
    let nextExhibit = function () {
        if (currentExhibits.length === 0) return;
        currentIndex = (currentIndex + 1) % currentExhibits.length;
        displayCurrentExhibit();
    }

    // 添加一下，进入添加界面了
    let switchToAddMode = function () {
        $('#exhibit-display-section').fadeOut(300, function() {
            $('#add-exhibit-section').fadeIn(300);
            $('#exhibitFormTitle').text("添加新展品");
            $('#addExhibitBtn').show();
            $('#updateExhibitBtn').hide();

            // 清空表单
            $("#addExhibitCode").val("");
            $("#addExhibitName").val("");
            $("#addExhibitDescription").val("");
            $("#imagePath").val("");
        });
    }

    // show-time
    let switchToDisplayMode = function () {
        $('#add-exhibit-section').fadeOut(300, function() {
            $('#exhibit-display-section').fadeIn(300);
            loadExhibits();
        });
    }

    // 编辑
    let editCurrentExhibit = function () {
        if (currentExhibits.length === 0) {
            alert('当前没有可编辑的展品！');
            return;
        }
        const exhibit = currentExhibits[currentIndex];

        // 显示编辑表单
        $('#exhibit-display-section').fadeOut(300, function() {
            $('#add-exhibit-section').fadeIn(300);
            $('#exhibitFormTitle').text("编辑展品");
            $('#addExhibitBtn').hide();
            $('#updateExhibitBtn').show();

            // 填充数据
            $("#addExhibitCode").val(exhibit.exhibitCode);
            $("#addExhibitName").val(exhibit.exhibitName);
            $("#addExhibitDescription").val(exhibit.description || '');
            $("#imagePath").val(exhibit.imagePath || '');

            // 设置当前编辑的展品ID
            window.currentEditExhibitId = exhibit.id;
        });
    }

    // 上传图片功能
    let uploadImageForCurrentExhibit = function () {
        if (currentExhibits.length === 0) {
            alert('当前没有可上传图片的展品！');
            return;
        }

        let fileInput = document.createElement('input');
        fileInput.type = 'file';
        fileInput.accept = 'image/jpeg,image/png,image/gif,image/jpg';

        fileInput.onchange = function(e) {
            let file = e.target.files[0];
            if (file) {
                const allowedTypes = ['image/jpeg', 'image/png', 'image/gif', 'image/jpg'];
                if (!allowedTypes.includes(file.type.toLowerCase())) {
                    alert('只允许上传JPEG、PNG、GIF格式的图片');
                    return;
                }

                let formData = new FormData();
                const exhibit = currentExhibits[currentIndex];

                formData.append('exhibitCode', exhibit.exhibitCode);
                formData.append('image', file);

                // 显示上传中提示
                if (message) message.html("正在上传图片...");

                // 发送上传请求
                $.ajax({
                    url: uploadExhibitsImageUrl,
                    type: 'POST',
                    data: formData,
                    processData: false,
                    contentType: false,
                    success: function(response) {
                        if (response.code === 200) {
                            if (message) message.html("图片上传成功");
                            exhibit.imagePath = response.data;
                            displayCurrentExhibit();
                        } else {
                            if (message) message.html("上传失败：" + response.message);
                        }
                    },
                    error: function(xhr, status, error) {
                        if (message) message.html("上传失败：" + error);
                    }
                });
            }
        };

        fileInput.click();
    };

    let deleteCurrentExhibit = function () {
        if (currentExhibits.length === 0) {
            alert('当前没有可删除的展品！');
            return;
        }

        const exhibit = currentExhibits[currentIndex];
        if (confirm('确定要删除展品"' + exhibit.exhibitName + '"吗？')) {
            // 记住当前索引，用于删除后的处理
            const deleteIndex = currentIndex;

            exhibitSubmit(exhibitDeleteUrl, exhibit);


            if (currentExhibits.length > 0) {
                // 删除后跳转前一个展品，如果是第一个就不变了
                if (deleteIndex > 0) {
                    currentIndex = deleteIndex - 1;
                } else {
                    currentIndex = 0; // 如果删除的是第一个，就显示现在的第一个
                }
                displayCurrentExhibit();
            } else {
                // 没有展品了，显示空状态
                showNoExhibit();
            }
        }
    }

    let gatherExhibitData = function () {
        const exhibitCode = $('#addExhibitCode').val();
        const exhibitName = $('#addExhibitName').val();
        const description = $('#addExhibitDescription').val();
        const imagePath = $('#imagePath').val();

        if (!exhibitCode || !exhibitName || !description) {
            alert('请填写完整的展品信息！');
            return null;
        }

        let exhibit = {
            id: window.currentEditExhibitId || 0,
            exhibitCode: exhibitCode,
            exhibitName: exhibitName,
            description: description,
            categoryId: window.currentCategoryId
        };

        if (imagePath && imagePath.trim() !== '') {
            exhibit.imagePath = imagePath;
        }

        return exhibit;
    }

    let exhibitAdd = function () {
        let exhibit = gatherExhibitData();
        if (!exhibit) return;

        const url = window.currentEditExhibitId ? exhibitUpdateUrl : exhibitAddUrl;
        exhibitSubmit(url, exhibit);

        if (!window.currentEditExhibitId) {
            currentIndex = 0;
        }
        displayCurrentExhibit();
    }

    let exhibitDelete = function (exhibit) {
        exhibitSubmit(exhibitDeleteUrl, exhibit);
        previousExhibit();
    }

    let exhibitSubmit = function (url, data) {
        if (message) message.html("");

        request("post", url, data, function(response) {
            if (message) message.html(response.description);

            if (response.code === 200) {
                // 重置编辑状态
                window.currentEditExhibitId = null;

                // 新增：显示当前展品ID和编号
                $('#currentExhibitId').text('000');
                $('#currentExhibitCode').text('000000');
                // previousExhibit();
                // 返回展示模式
                switchToDisplayModeWithAnimation();
            } else {
                alert('操作失败：' + response.message);
            }
        }, function(jqXHR, textStatus) {
            if (message) message.html(jqXHR.responseText || '请求失败');
            alert('网络请求失败！');
        }, true);
    }

    //  通用功能
    // 刷新数据
    function refreshData() {
        // 添加刷新动画
        $('.nav-item#nav-refresh').addClass('active');

        setTimeout(() => {
            $('.nav-item#nav-refresh').removeClass('active');

            if (currentPage === 'category') {
                loadDataToCategoryTable(categoryListUrl, refreshCategoryTable, submitFailed);
            } else if (currentPage === 'exhibit') {
                loadExhibits();
            }
            alert('数据已刷新！');
        }, 500);
    }

    //AJAX请求函数
    function request(method, url, data, success, fail, showLoading) {
        $.ajax({
            type: method,
            url: url,
            contentType: "application/json",
            data: JSON.stringify(data),
            dataType: "json",
            success: success,
            error: fail
        });
    }

    // 处理浏览器前进/后退
    window.onpopstate = function(event) {
        if (event.state && event.state.page) {
            if (event.state.page === 'home') {
                toHome();
            } else if (event.state.page === 'category') {
                showCategoryPage();
            } else if (event.state.page === 'exhibit') {
                const urlParams = new URLSearchParams(window.location.search);
                const categoryId = urlParams.get('categoryId');
                if (categoryId) {
                    showExhibitPage(categoryId);
                }
            }
        }
    };
</script>
</body>
</html>

