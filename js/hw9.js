// ============================================================
// hw9.js — JavaScript ที่ใช้ร่วมกันหลายหน้า (about.aspx, contact.aspx,
// guestbook.aspx, index.html, portfolio.html)
// ฟีเจอร์: ตรวจสอบฟอร์มก่อน submit, แสดง/ซ่อนข้อมูล, alert แจ้งเตือน
// ============================================================

// ---- 1. ตรวจสอบฟอร์มติดต่อ (contact.aspx) ----
function validateContactForm() {
    var name = document.getElementById("name").value.trim();
    var email = document.getElementById("email").value.trim();
    var message = document.getElementById("message").value.trim();

    if (name === "") {
        alert("กรุณากรอกชื่อ-นามสกุล");
        return false;
    }

    if (email === "") {
        alert("กรุณากรอกอีเมล");
        return false;
    }

    var emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailPattern.test(email)) {
        alert("รูปแบบอีเมลไม่ถูกต้อง กรุณาตรวจสอบอีกครั้ง");
        return false;
    }

    if (message === "") {
        alert("กรุณากรอกข้อความ");
        return false;
    }

    return true; // ผ่านการตรวจสอบ ให้ฟอร์ม submit ไปที่ contact.aspx
}

// ---- 2. ตรวจสอบฟอร์มสมุดเยี่ยมชม (guestbook.aspx) ----
function validateGuestbookForm() {
    var name = document.getElementById("gbName").value.trim();
    var msg = document.getElementById("gbMessage").value.trim();

    if (name === "") {
        alert("กรุณากรอกชื่อ");
        return false;
    }

    if (msg === "") {
        alert("กรุณากรอกข้อความ");
        return false;
    }

    if (msg.length > 300) {
        alert("ข้อความยาวเกินไป กรุณากรอกไม่เกิน 300 ตัวอักษร");
        return false;
    }

    return true; // ผ่านการตรวจสอบ ให้ฟอร์ม submit ไปที่ guestbook.aspx
}

// ---- 3. แสดง/ซ่อนข้อมูลเพิ่มเติมในหน้า about.aspx ----
function toggleAboutExtra() {
    var box = document.getElementById("aboutExtra");
    if (!box) return;

    if (box.style.display === "none" || box.style.display === "") {
        box.style.display = "block";
    } else {
        box.style.display = "none";
    }
}

// ---- 4. คำทักทายตามช่วงเวลาสำหรับหน้าแรก (index.html) ----
function showTimeGreeting(elementId) {
    var el = document.getElementById(elementId);
    if (!el) return;

    var hour = new Date().getHours();
    var greeting = "";

    if (hour < 12) {
        greeting = "สวัสดีครับ 😎 ยินดีต้อนรับสู่เว็บไซต์ของผม";
    } else if (hour < 18) {
        greeting = "สวัสดีครับ 😀 ยินดีต้อนรับสู่เว็บไซต์ของผม";
    } else {
        greeting = "สวัสดีครับ 🫩 ยินดีต้อนรับสู่เว็บไซต์ของผม";
    }

    el.textContent = greeting;
}

// ---- 5. กรองผลงานในหน้า portfolio.html ตามคำค้นหา ----
function filterPortfolio(inputId, cardSelector) {
    var input = document.getElementById(inputId);
    if (!input) return;

    var keyword = input.value.toLowerCase();
    var cards = document.querySelectorAll(cardSelector);

    cards.forEach(function (card) {
        var text = card.textContent.toLowerCase();
        card.style.display = text.indexOf(keyword) !== -1 ? "" : "none";
    });
}

// เรียกคำทักทายอัตโนมัติเมื่อโหลดหน้า (ถ้ามี element #greeting อยู่ในหน้านั้น)
document.addEventListener("DOMContentLoaded", function () {
    if (document.getElementById("greeting")) {
        showTimeGreeting("greeting");
    }
});
