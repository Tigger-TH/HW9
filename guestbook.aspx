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
    // ===== เก็บข้อความแต่ละรายการเป็น string[4]: {id, name, message, postedTime} =====
    // (ตั้งใจไม่ใช้ custom class เพราะ ASP.NET จะคอมไพล์คลาสที่ประกาศใน .aspx ใหม่
    //  ทุกครั้งที่ไฟล์ถูกแก้ไข ทำให้ object เก่าที่ค้างอยู่ใน Application State
    //  กลายเป็นคนละ Type กับคลาสเวอร์ชันใหม่ และ cast ไม่ได้ -> InvalidCastException
    //  string[] เป็น Type มาตรฐานของ .NET จึงไม่มีปัญหานี้)

    string statusType = "";
    string statusText = "";

    // อ่าน IP จริงของผู้เข้าชม แม้จะมี Cloudflare พร็อกซี่อยู่หน้าเว็บก็ตาม
    string GetClientIp()
    {
        string cfIp = Request.Headers["CF-Connecting-IP"];
        if (!string.IsNullOrEmpty(cfIp)) return cfIp;

        string forwardedFor = Request.Headers["X-Forwarded-For"];
        if (!string.IsNullOrEmpty(forwardedFor))
        {
            return forwardedFor.Split(',')[0].Trim();
        }

        return Request.UserHostAddress;
    }

    // ===== เก็บข้อความไว้ใน Application State (ใช้ร่วมกันทุกคนที่เข้าเว็บ ไม่ต้องใช้ Database) =====
    List<string[]> GetMessages()
    {
        if (Application["GuestbookMessages"] == null)
        {
            Application.Lock();
            if (Application["GuestbookMessages"] == null)
            {
                Application["GuestbookMessages"] = new List<string[]>();
            }
            Application.UnLock();
        }
        return (List<string[]>)Application["GuestbookMessages"];
    }

    void Page_Load(object sender, EventArgs e)
    {
        if (Request.HttpMethod == "POST")
        {
            // Form >> ASPX : ตรวจสอบการ submit ฟอร์มฝากข้อความ
            if (Request.Form["submitGuestbook"] != null)
            {
                string name = (Request.Form["gbName"] ?? "").Trim();
                string message = (Request.Form["gbMessage"] ?? "").Trim();

                if (name.Length > 0 && message.Length > 0)
                {
                    string newId = Guid.NewGuid().ToString("N");
                    string postedTime = DateTime.Now.ToString("dd/MM/yyyy HH:mm") + " น.";
                    string[] newEntry = new string[] {
                        newId,
                        Server.HtmlEncode(name),
                        Server.HtmlEncode(message),
                        postedTime
                    };

                    List<string[]> list = GetMessages();
                    Application.Lock();
                    list.Insert(0, newEntry);
                    Application.UnLock();

                    // Post/Redirect/Get: redirect กลับไปแบบ GET กันข้อมูลซ้ำเวลากด F5
                    Response.Redirect("guestbook.aspx?status=success&name=" + Server.UrlEncode(name));
                    return;
                }
                else
                {
                    Response.Redirect("guestbook.aspx?status=error");
                    return;
                }
            }
            // ตรวจสอบการ submit ฟอร์มลบข้อความ (ปุ่ม 🗑️ ลบ ในแต่ละรายการ)
            else if (Request.Form["deleteId"] != null)
            {
                string deleteId = Request.Form["deleteId"];
                List<string[]> list = GetMessages();

                Application.Lock();
                list.RemoveAll(item => item[0] == deleteId);
                Application.UnLock();

                // Post/Redirect/Get: redirect กลับไปแบบ GET กันการลบซ้ำเวลากด F5
                Response.Redirect("guestbook.aspx?status=deleted");
                return;
            }
        }
        else
        {
            // GET request: เช็คว่า redirect มาจากการ submit/delete สำเร็จหรือไม่
            string status = Request.QueryString["status"];
            if (status == "success")
            {
                statusType = "success";
                string qName = Server.HtmlEncode(Request.QueryString["name"] ?? "");
                statusText = "ขอบคุณสำหรับข้อความของคุณ " + qName + " ครับ/ค่ะ!";
            }
            else if (status == "error")
            {
                statusType = "error";
                statusText = "กรุณากรอกทั้งชื่อและข้อความก่อนส่งนะครับ";
            }
            else if (status == "deleted")
            {
                statusType = "success";
                statusText = "ลบข้อความเรียบร้อยแล้ว";
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
        &nbsp;|&nbsp; 🌐 IP ของคุณ: <strong><%= GetClientIp() %></strong>
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
        <% foreach (string[] entry in GetMessages()) {
             string entryId = entry[0];
             string entryName = entry[1];
             string entryMessage = entry[2];
             string entryTime = entry[3];
        %>
          <div class="gb-entry">
            <div class="gb-entry__head">
              <span class="gb-entry__name">👤 <%= entryName %></span>
              <span class="gb-entry__time"><%= entryTime %></span>
            </div>
            <p class="gb-entry__message"><%= entryMessage %></p>
            <form method="post" action="guestbook.aspx" class="gb-entry__delete-form"
                  onsubmit="return confirm('ต้องการลบข้อความนี้ใช่หรือไม่?');">
              <input type="hidden" name="deleteId" value="<%= entryId %>">
              <button type="submit" class="btn btn-ghost btn-sm">🗑️ ลบ</button>
            </form>
          </div>
        <% } %>
        <% if (GetMessages().Count == 0) { %>
          <p class="hint">ยังไม่มีข้อความในสมุดเยี่ยมชม เป็นคนแรกที่ฝากข้อความสิ!</p>
        <% } %>
      </div>
    </div>
  </section>
</main>

<footer class="site-footer">
  <div class="container">
    6810301012 &middot; Homework 10
  </div>
</footer>

<script src="js/hw9.js"></script>
</body>
</html>
