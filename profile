<!DOCTYPE html>
<html lang="th">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
  <title>ข้อมูลส่วนตัว - LWS FIT</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
  
  <style>
    body { background-color: #f4f7f6; font-family: 'Sarabun', sans-serif; -ms-overflow-style: none; scrollbar-width: none; padding-bottom: 40px; }
    ::-webkit-scrollbar { display: none; }
    * { -webkit-tap-highlight-color: transparent; }
    
    .container { max-width: 480px !important; margin: 0 auto; padding: 0 15px; }
    .card { border-radius: 16px; box-shadow: 0 4px 20px rgba(0,0,0,0.04); border: none; margin-bottom: 15px; }
    
    .profile-header { background: linear-gradient(135deg, #0d6efd, #0dcaf0); color: white; border-radius: 16px; padding: 30px 20px; text-align: center; margin-top: 20px; margin-bottom: 20px; box-shadow: 0 4px 15px rgba(13,110,253,0.2); }
    .avatar-circle { width: 80px; height: 80px; background-color: rgba(255,255,255,0.2); border-radius: 50%; display: inline-flex; align-items: center; justify-content: center; font-size: 35px; margin-bottom: 10px; border: 2px solid white; }
    
    .info-label { font-size: 12px; color: #6c757d; font-weight: bold; margin-bottom: 2px; }
    .info-value { font-size: 16px; color: #212529; font-weight: bold; margin-bottom: 15px; border-bottom: 1px solid #f0f0f0; padding-bottom: 8px; }
    
    .point-box { background-color: #fff3cd; border-radius: 12px; padding: 15px; text-align: center; border: 1px solid #ffecb5; }
    .point-number { font-size: 28px; font-weight: bold; color: #856404; margin: 0; }
    
    .btn-back { background-color: #e9ecef; color: #495057; width: 100%; margin-top: 10px; border-radius: 12px; padding: 12px 20px; font-weight: bold; border: none; }
  </style>
</head>
<body>

<div id="loading" class="text-center" style="margin-top: 100px;">
  <div class="spinner-border text-primary" role="status"></div>
  <p class="mt-3 text-muted fw-bold">กำลังค้นหาข้อมูลของคุณ...</p>
</div>

<div class="container" id="profileContainer" style="display: none;">
  
  <div class="profile-header">
    <div class="avatar-circle">👤</div>
    <h4 class="fw-bold mb-0" id="showName">กำลังโหลด...</h4>
    <span class="badge bg-light text-primary mt-2 rounded-pill px-3" id="showType">สมาชิกระดับเริ่มต้น</span>
  </div>

  <div class="row mb-3">
    <div class="col-6 pe-2">
      <div class="card p-3 h-100 text-center" style="background-color: #e0f8e9; border: 1px solid #c3e6cb;">
        <span class="info-label text-success">ก้าวสะสมทั้งหมด</span>
        <h3 class="fw-bold text-success mb-0 mt-1" id="showSteps">0</h3>
        <small class="text-success" style="font-size: 10px;">ก้าว</small>
      </div>
    </div>
    <div class="col-6 ps-2">
      <div class="card p-3 h-100 text-center point-box">
        <span class="info-label" style="color: #856404;">คะแนนที่ใช้ได้</span>
        <h3 class="point-number mt-1" id="showPoints">0</h3>
        <small style="color: #856404; font-size: 10px;">พอยท์</small>
      </div>
    </div>
  </div>

  <div class="card p-4">
    <h6 class="fw-bold text-primary mb-3">📋 ข้อมูลการลงทะเบียน</h6>
    
    <div class="info-label">เบอร์โทรศัพท์</div>
    <div class="info-value" id="showPhone">-</div>
    
    <div class="info-label">ร้านค้า / โครงการ</div>
    <div class="info-value" id="showProject">-</div>
    
    <div class="info-label">จังหวัด</div>
    <div class="info-value" id="showProvince">-</div>
  </div>

  <button type="button" class="btn-back" onclick="window.location.href='index.html'">กลับหน้าแรก</button>
  
</div>

<script>
  const urlParams = new URLSearchParams(window.location.search);
  const currentUid = urlParams.get('uid');
  
  // 🚨 ใส่ลิงก์ Deploy ของ Google Apps Script ที่นี่ (ลิงก์เดิมที่ใช้ในหน้า register)
  const GAS_URL = "https://script.google.com/macros/s/AKfycbw0jdlT9JewPZLbAOtKvdpE3bxFkMM6qXFRWoWZH5RmDgxt3w_A9nUrV1uJ_cNJFFW6qA/exec"; 

  window.onload = function() {
    if(!currentUid) {
      Swal.fire({ icon: 'error', title: 'ไม่พบข้อมูล', text: 'กรุณาเข้าใช้งานผ่านเมนูใน LINE' })
        .then(() => { window.location.href = 'index.html'; });
      return;
    }
    fetchProfileData();
  };

  function fetchProfileData() {
    const payload = {
      action: "getProfile",
      userId: currentUid
    };

    fetch(GAS_URL, {
      redirect: "follow",
      method: 'POST',
      headers: { "Content-Type": "text/plain;charset=utf-8" },
      body: JSON.stringify(payload)
    })
    .then(response => response.json())
    .then(result => {
      if (result.status === "success") {
        // เอาข้อมูลมาแปะลงบนหน้าเว็บ
        document.getElementById('showName').innerText = result.data.name;
        document.getElementById('showPhone').innerText = result.data.phone;
        document.getElementById('showProject').innerText = result.data.project;
        document.getElementById('showProvince').innerText = result.data.province;
        document.getElementById('showType').innerText = result.data.customerType;
        
        // ซ่อนตัวโหลด โชว์ข้อมูล
        document.getElementById('loading').style.display = 'none';
        document.getElementById('profileContainer').style.display = 'block';
      } else if (result.status === "not_found") {
        Swal.fire({
          icon: 'warning',
          title: 'ยังไม่ได้เป็นสมาชิก',
          text: 'กรุณาลงทะเบียนก่อนเข้าดูข้อมูลส่วนตัวครับ',
          confirmButtonText: 'ไปหน้าลงทะเบียน'
        }).then(() => {
          window.location.href = 'register.html?uid=' + currentUid;
        });
      }
    })
    .catch(error => {
      Swal.fire('การเชื่อมต่อขัดข้อง', 'ไม่สามารถดึงข้อมูลได้', 'error')
        .then(() => { window.location.href = 'index.html'; });
    });
  }
</script>
</body>
</html>
