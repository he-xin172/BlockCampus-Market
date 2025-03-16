document.addEventListener('DOMContentLoaded', () => {
    // 初始加载，检查本地存储中是否有用户信息
    const user = JSON.parse(localStorage.getItem('user'));
    if (user) {
      showLoggedInUI(user);
    } else {
      showLoggedOutUI();
    }
  
    // 显示登录页面
    document.querySelector('a[href="#login"]').addEventListener('click', (event) => {
      event.preventDefault();
      showSection('login');
    });
  
    // 处理登录表单提交
    document.getElementById('loginForm').addEventListener('submit', (event) => {
      event.preventDefault();
      const username = document.getElementById('loginUsername').value;
      const password = document.getElementById('loginPassword').value;
      const role = document.getElementById('loginRole').value;
  
      // 这里可以添加登录逻辑，这里只是模拟保存到本地存储
      const user = { username, role };
      localStorage.setItem('user', JSON.stringify(user));
      showLoggedInUI(user);
    });
  
    // 显示注册页面
    document.querySelector('a[href="#register"]').addEventListener('click', (event) => {
      event.preventDefault();
      showSection('register');
    });
  
    // 处理注册表单提交
    document.getElementById('registerForm').addEventListener('submit', (event) => {
      event.preventDefault();
      const username = document.getElementById('registerUsername').value;
      const password = document.getElementById('registerPassword').value;
      const role = document.getElementById('registerRole').value;
  
      // 这里可以添加注册逻辑，这里只是模拟保存到本地存储
      const user = { username, role };
      localStorage.setItem('user', JSON.stringify(user));
      showLoggedInUI(user);
    });
  
    // 登出功能
    document.getElementById('logoutBtn').addEventListener('click', () => {
      localStorage.removeItem('user');
      showLoggedOutUI();
    });
  
    // 页面导航切换
    const showSection = (sectionId) => {
      const sections = document.querySelectorAll('section');
      sections.forEach(section => {
        if (section.id === sectionId) {
          section.style.display = 'block';
        } else {
          section.style.display = 'none';
        }
      });
    };
  
    // 显示登录后的界面
    const showLoggedInUI = (user) => {
      document.getElementById('userInfo').innerHTML = `
        <p>当前用户: ${user.username}</p>
        <p>身份: ${user.role === 'buyer' ? '买家' : '卖家'}</p>
        <button id="logoutBtn">登出</button>
      `;
      showSection('home');
    };
  
    // 显示未登录的界面
    const showLoggedOutUI = () => {
      document.getElementById('userInfo').innerHTML = '';
      showSection('home');
    };
  });
  