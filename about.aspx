<%@ Page Language="C#" %>
<!DOCTYPE html>
<html lang="th">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>About | HW9</title>
<meta name="description" content="แนะนำตัวและความสนใจด้านเทคนิคของนักศึกษา">
<link rel="stylesheet" href="css/style.css">
<link rel="stylesheet" href="css/hw9.css">
</head>

<script runat="server">
    string GetGreeting()
    {
        int hour = DateTime.Now.Hour;
        if (hour < 12) return "สวัสดีตอนเช้าครับ 😎";
        if (hour < 18) return "สวัสดีตอนบ่ายครับ 😀";
        return "สวัสดีตอนเย็น/ค่ำครับ 🫩";
    }

    // อ่าน IP จริงของผู้เข้าชม แม้จะมี Cloudflare พร็อกซี่อยู่หน้าเว็บก็ตาม
    string GetClientIp()
    {
        // 1) Cloudflare แนบ IP จริงมาใน header นี้เสมอเมื่อพร็อกซี่ผ่าน Cloudflare
        string cfIp = Request.Headers["CF-Connecting-IP"];
        if (!string.IsNullOrEmpty(cfIp)) return cfIp;

        // 2) proxy/load balancer ทั่วไปมักแนบ IP มาใน header นี้ (อาจมีหลาย IP คั่นด้วย comma)
        string forwardedFor = Request.Headers["X-Forwarded-For"];
        if (!string.IsNullOrEmpty(forwardedFor))
        {
            return forwardedFor.Split(',')[0].Trim();
        }

        // 3) ถ้าไม่มี proxy เลย (เช่นทดสอบตรงจาก localhost/public-ip) ใช้ค่าปกติ
        return Request.UserHostAddress;
    }
</script>

<body>

<header class="site-header">
  <div class="container nav-wrap">
    <a class="brand" href="index.html"><em>Tigger</em></a>
    <nav class="nav" aria-label="เมนูหลัก">
      <a href="index.html">Home</a>
      <a href="about.aspx" aria-current="page">About</a>
      <a href="cv.html">CV</a>
      <a href="portfolio.html">Portfolio</a>
      <a href="contact.aspx">Contact</a>
      <a href="guestbook.aspx">Guestbook</a>
    </nav>
  </div>
</header>
<div class="course-bar"><div class="container">310-2203 Back-End Software Development</div></div>

<main>
  <section class="hero" style="padding-bottom:40px;">
    <div class="container">
      <span class="eyebrow">About me</span>
      <h1>เกี่ยวกับผม</h1>
      <p class="lead">เรื่องราวสั้น ๆ เกี่ยวกับตัวผม สิ่งที่กำลังเรียนรู้ และเครื่องมือที่ใช้งานอยู่เป็นประจำ</p>
      <p class="server-info-line">
        <%= GetGreeting() %> ขณะนี้เวลา <strong><%= DateTime.Now.ToString("HH:mm:ss") %></strong>
        วันที่ <strong><%= DateTime.Now.ToString("dd/MM/yyyy") %></strong> —
        คุณเข้าชมจาก IP <strong><%= GetClientIp() %></strong>
        <!-- <span class="hint">(ข้อความนี้คำนวณแบบ Dynamic ด้วย ASP.NET ทุกครั้งที่โหลดหน้า)</span> -->
      </p>
    </div>
  </section>

  <section class="section">
    <div class="container grid-2">
      <div>
        <h2>แนะนำตัว</h2>
        <p>ผมชื่อนฤชิต บุญยัง (GitHub: <a href="https://github.com/Tigger-TH" target="_blank" rel="noopener">Tigger-TH</a>) เป็นนักศึกษาชั้นปีที่ 2 สาขาวิศวกรรมคอมพิวเตอร์ คณะเทคโนโลยีดิจิทัล สถาบันเทคโนโลยีจิตรลดา สนใจด้าน Computer Networks และชอบศึกษาเรื่องระบบเครือข่าย</p>
        <p>เว็บไซต์นี้เป็นผลงานล่าสุด (HW9) ที่ต่อยอดจากเว็บไซต์แบบ Static ใน HW8 ให้กลายเป็นเว็บไซต์แบบ Dynamic ด้วย ASP.NET (C#) ร่วมกับ JavaScript</p>
      </div>
      <div>
        <h2>เครื่องมือที่ใช้ประจำ</h2>
        <div class="entity-grid" style="grid-template-columns:1fr;">
          <div class="entity-card">
            <div class="entity-card__head">
              <span class="entity-card__table">tools</span>
              <span class="pill">dev</span>
            </div>
            <div class="entity-card__body">
              <p style="margin:0;">Visual Studio (C# WinForms) &middot; Microsoft IIS &middot; ASP.NET &middot; VS Code &middot; Excel (Test Report) &middot; Git / GitHub</p>
            </div>
          </div>
        </div>
        <h2 style="margin-top:28px;">ความสนใจ</h2>
        <div class="tag-row">
          <span class="tag">Computer Networks</span>
          <span class="tag">Back-End Development</span>
          <span class="tag">C#</span>
          <span class="tag">HTML/CSS</span>
        </div>

        <button type="button" class="btn btn-ghost btn-sm" onclick="toggleAboutExtra()">
          ดูข้อมูลเพิ่มเติม ▾
        </button>

        <div id="aboutExtra" class="about-extra" style="display:none;">
          <h2 style="margin-top:0;">ภาษาที่ใช้ทำงาน</h2>
          <div class="tag-row">
            <span class="tag">ไทย</span>
            <span class="tag">English</span>
            <span class="tag">C#</span>
            <span class="tag">HTML/CSS</span>
          </div>
          <p style="margin-top:12px;">กำลังฝึกฝนเพิ่มเติมด้าน ASP.NET Web Forms การจัดการ State บนฝั่ง Server (Application/Session) และการ Deploy เว็บไซต์ขึ้น Cloud (Azure/AWS)</p>
        </div>
      </div>
    </div>
  </section>

  <section class="section section-alt">
    <div class="container">
      <h2>สิ่งที่กำลังสนใจตอนนี้</h2>
      <ul>
        <li>การออกแบบ UML Diagram (Use Case, Class, Sequence, Activity, State Machine, Component)</li>
        <li>การเขียนโปรแกรม Desktop ด้วย C# WinForms และการจัดการไฟล์ CSV</li>
        <li>การเก็บและวิเคราะห์ความต้องการผู้ใช้ (User Requirement Specification) สำหรับระบบ POS</li>
        <li>การพัฒนาเว็บไซต์แบบ Dynamic ด้วย ASP.NET + JavaScript การตั้งค่า IIS และการ Deploy ขึ้น Cloud</li>
      </ul>
    </div>
  </section>
</main>

<footer class="site-footer">
  <div class="container">
    <br>6810301012 &middot; Homework 10
  </div>
</footer>

<script src="js/hw9.js"></script>
</body>
</html>
