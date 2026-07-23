<%@ Page Language="C#" %>
<!DOCTYPE html>
<html lang="th">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Contact | HW9</title>
<meta name="description" content="ส่งข้อความติดต่อผ่านฟอร์ม หรือดูช่องทางติดต่ออื่น ๆ">
<link rel="stylesheet" href="css/style.css">
<link rel="stylesheet" href="css/hw9.css">
</head>

<script runat="server">
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

    void Page_Load(object sender, EventArgs e)
    {
        // Form >> ASPX : ตรวจสอบว่ามีการ submit ฟอร์มติดต่อมาหรือไม่
        if (Request.HttpMethod == "POST" && Request.Form["submitContact"] != null)
        {
            string name = (Request.Form["name"] ?? "").Trim();
            string email = (Request.Form["email"] ?? "").Trim();
            string message = (Request.Form["message"] ?? "").Trim();

            if (name.Length > 0 && email.Length > 0 && message.Length > 0)
            {
                // Post/Redirect/Get: redirect กลับไปแบบ GET กันข้อมูลซ้ำเวลากด F5
                // จับเวลาที่ส่งจริงไว้ตรงนี้ แล้วส่งผ่าน query string ไป
                // เพื่อไม่ให้เวลาขยับเปลี่ยนทุกครั้งที่กด F5 โหลดหน้าซ้ำ
                string submittedAt = DateTime.Now.ToString("dd/MM/yyyy HH:mm:ss");
                Response.Redirect("contact.aspx?status=success"
                    + "&name=" + Server.UrlEncode(name)
                    + "&email=" + Server.UrlEncode(email)
                    + "&time=" + Server.UrlEncode(submittedAt));
                return;
            }
            else
            {
                Response.Redirect("contact.aspx?status=error");
                return;
            }
        }
        else if (Request.HttpMethod != "POST")
        {
            string status = Request.QueryString["status"];
            if (status == "success")
            {
                statusType = "success";
                string qName = Server.HtmlEncode(Request.QueryString["name"] ?? "");
                string qEmail = Server.HtmlEncode(Request.QueryString["email"] ?? "");
                string qTime = Server.HtmlEncode(Request.QueryString["time"] ?? DateTime.Now.ToString("dd/MM/yyyy HH:mm:ss"));
                statusText = "ขอบคุณครับคุณ " + qName +
                             " เราได้รับข้อความของคุณแล้ว จะติดต่อกลับไปที่ " + qEmail +
                             " เร็ว ๆ นี้ (บันทึกเวลาที่ส่ง: " + qTime + ")";
            }
            else if (status == "error")
            {
                statusType = "error";
                statusText = "กรุณากรอกข้อมูลให้ครบทุกช่องก่อนส่งฟอร์มนะครับ";
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
      <a href="contact.aspx" aria-current="page">Contact</a>
      <a href="guestbook.aspx">Guestbook</a>
    </nav>
  </div>
</header>
<div class="course-bar"><div class="container">310-2203 Back-End Software Development</div></div>

<main>
  <section class="hero" style="padding-bottom:40px;">
    <div class="container">
      <span class="eyebrow">contact</span>
      <h1>ติดต่อผม</h1>
      <p class="lead">มีคำถามเกี่ยวกับผลงาน อยากพูดคุยเรื่องโปรเจกต์ หรือแค่อยากทักทาย ส่งข้อความมาได้ที่ฟอร์มด้านล่าง</p>
      <p class="server-info-line">
        🌐 ระบบตรวจพบว่าคุณกำลังเข้าชมจาก IP: <strong><%= GetClientIp() %></strong>
        &nbsp;|&nbsp; 🕒 <%= DateTime.Now.ToString("dd/MM/yyyy HH:mm:ss") %>
      </p>
    </div>
  </section>

  <section class="section">
    <div class="container grid-2">

      <div>
        <% if (statusText != "") { %>
          <div class="gb-alert gb-alert--<%= statusType %>"><%= statusText %></div>
        <% } %>

        <form class="form-grid" method="post" action="contact.aspx" onsubmit="return validateContactForm();">
          <div class="field">
            <label for="name">ชื่อ-นามสกุล</label>
            <input type="text" id="name" name="name" placeholder="กรอกชื่อของคุณ">
          </div>
          <div class="field">
            <label for="email">อีเมล</label>
            <input type="email" id="email" name="email" placeholder="you@example.com">
            <p class="hint">ผมจะใช้อีเมลนี้ในการตอบกลับเท่านั้น</p>
          </div>
          <div class="field">
            <label for="message">ข้อความ</label>
            <textarea id="message" name="message" placeholder="พิมพ์ข้อความของคุณที่นี่..."></textarea>
          </div>
          <div>
            <button type="submit" name="submitContact" value="1" class="btn btn-primary">ส่งข้อความ</button>
          </div>
        </form>
      </div>

      <div class="contact-info">
        <div class="item">
          <div>
            <strong>GitHub</strong>
            <a href="https://github.com/Tigger-TH" target="_blank" rel="noopener">github.com/Tigger-TH</a>
          </div>
        </div>
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
