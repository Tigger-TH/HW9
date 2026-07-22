<%@ Page Language="C#" %>
<%@ Import Namespace="System.Collections.Generic" %>
<!DOCTYPE html>
<html lang="th">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Guestbook | HW9</title>
<meta name="description" content="สมุดเยี่ยมชม ฝากข้อความถึงเจ้าของเว็บไซต์">
<link rel="stylesheet" href="css/style.css">
<link rel="stylesheet" href="css/hw9.css">
</head>

<script runat="server">
    // ===== โครงสร้างข้อมูล 1 ข้อความในสมุดเยี่ยมชม =====
    public class GuestEntry
    {
        public string Name;
        public string Message;
        public string PostedTime;

        public GuestEntry(string name, string message)
        {
            Name = name;
            Message = message;
            PostedTime = DateTime.Now.ToString("dd/MM/yyyy HH:mm") + " น.";
        }
    }

    string statusType = "";
    string statusText = "";

    // ===== เก็บข้อความไว้ใน Application State (ใช้ร่วมกันทุกคนที่เข้าเว็บ ไม่ต้องใช้ Database) =====
    List<GuestEntry> GetMessages()
    {
        if (Application["GuestbookMessages"] == null)
        {
            Application.Lock();
            if (Application["GuestbookMessages"] == null)
            {
                List<GuestEntry> initial = new List<GuestEntry>();
                initial.Add(new GuestEntry("คุณ A", "เว็บไซต์สวยมากครับ ออกแบบเป็นระเบียบและดูเป็นมืออาชีพดี"));
                initial.Add(new GuestEntry("คุณ B", "ขอชื่นชมผลงาน Portfolio ที่รวบรวมไว้ครบถ้วนมากค่ะ"));
                Application["GuestbookMessages"] = initial;
            }
            Application.UnLock();
        }
        return (List<GuestEntry>)Application["GuestbookMessages"];
    }

    void Page_Load(object sender, EventArgs e)
    {
        // Form >> ASPX : ตรวจสอบการ submit ฟอร์ม
        if (Request.HttpMethod == "POST" && Request.Form["submitGuestbook"] != null)
        {
            string name = (Request.Form["gbName"] ?? "").Trim();
            string message = (Request.Form["gbMessage"] ?? "").Trim();

            if (name.Length > 0 && message.Length > 0)
            {
                List<GuestEntry> list = GetMessages();
                Application.Lock();
                list.Insert(0, new GuestEntry(Server.HtmlEncode(name), Server.HtmlEncode(message)));
                Application.UnLock();

                statusType = "success";
                statusText = "ขอบคุณสำหรับข้อความของคุณ " + Server.HtmlEncode(name) + " ครับ/ค่ะ!";
            }
            else
            {
                statusType = "error";
                statusText = "กรุณากรอกทั้งชื่อและข้อความก่อนส่งนะครับ";
            }
        }
    }
</script>

<body>

<header class="site-header">
  <div class="container nav-wrap">
    <a class="brand" href="index.html"><em>Tigger</em></a>
    <nav class="nav" aria-label="เมนูหลัก">
      <a href="index.html">Home</a>
      <a href="about.aspx">About</a>
      <a href="cv.html">CV</a>
      <a href="portfolio.html">Portfolio</a>
      <a href="contact.aspx">Contact</a>
      <a href="guestbook.aspx" aria-current="page">Guestbook</a>
    </nav>
  </div>
</header>
<div class="course-bar"><div class="container">310-2203 Back-End Software Development</div></div>

<main>
  <section class="hero" style="padding-bottom:40px;">
    <div class="container">
      <span class="eyebrow">guestbook</span>
      <h1>📖 สมุดเยี่ยมชม</h1>
      <p class="lead">หน้านี้พัฒนาด้วย ASP.NET (C#) แบบ Dynamic ใช้ Application State เก็บข้อความของผู้เยี่ยมชมทุกคนไว้บนเซิร์ฟเวอร์ ไม่ต้องใช้ฐานข้อมูล</p>
      <p class="server-info-line">
        🕒 เวลาปัจจุบันของเซิร์ฟเวอร์: <strong><%= DateTime.Now.ToString("dd/MM/yyyy HH:mm:ss") %></strong>
        &nbsp;|&nbsp; 🌐 IP ของคุณ: <strong><%= Request.UserHostAddress %></strong>
      </p>
    </div>
  </section>

  <section class="section">
    <div class="container">

      <% if (statusText != "") { %>
        <div class="gb-alert gb-alert--<%= statusType %>"><%= statusText %></div>
      <% } %>

      <h2>ฝากข้อความถึงเจ้าของเว็บไซต์</h2>
      <form class="gb-form" method="post" action="guestbook.aspx" onsubmit="return validateGuestbookForm();">
        <div class="field">
          <label for="gbName">ชื่อ</label>
          <input type="text" id="gbName" name="gbName" placeholder="ชื่อของคุณ">
        </div>
        <div class="field">
          <label for="gbMessage">ข้อความ</label>
          <textarea id="gbMessage" name="gbMessage" rows="4" placeholder="เขียนความคิดเห็นถึงเว็บไซต์นี้..."></textarea>
        </div>
        <div>
          <button type="submit" name="submitGuestbook" value="1" class="btn btn-primary">ส่งข้อความ</button>
        </div>
      </form>
    </div>
  </section>

  <section class="section section-alt">
    <div class="container">
      <h2>ข้อความจากผู้เยี่ยมชม (<%= GetMessages().Count %>)</h2>
      <div class="gb-list">
        <% foreach (GuestEntry entry in GetMessages()) { %>
          <div class="gb-entry">
            <div class="gb-entry__head">
              <span class="gb-entry__name">👤 <%= entry.Name %></span>
              <span class="gb-entry__time"><%= entry.PostedTime %></span>
            </div>
            <p class="gb-entry__message"><%= entry.Message %></p>
          </div>
        <% } %>
      </div>
    </div>
  </section>
</main>

<footer class="site-footer">
  <div class="container">
    6810301012 &middot; Deployed on GitHub Pages
  </div>
</footer>

<script src="js/hw9.js"></script>
</body>
</html>
