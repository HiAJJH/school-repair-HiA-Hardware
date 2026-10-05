-- ============================================================
-- 内容管理：服务项目表 + 网站设置表
-- 在 Supabase → SQL Editor 粘贴整段运行一次即可
-- ============================================================

-- 服务项目表
create table if not exists public.services (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  description text,
  price text,
  sort_order int not null default 0,
  created_at timestamptz not null default now()
);

-- 网站设置表（键值对）
create table if not exists public.settings (
  key text primary key,
  value text
);

-- 开启行级安全
alter table public.services enable row level security;
alter table public.settings enable row level security;

-- ---------- services 策略 ----------
drop policy if exists "services匿名查看" on public.services;
create policy "services匿名查看" on public.services
  for select to anon, authenticated using (true);

drop policy if exists "services登录增删改" on public.services;
create policy "services登录增删改" on public.services
  for all to authenticated using (true) with check (true);

-- ---------- settings 策略 ----------
drop policy if exists "settings匿名查看" on public.settings;
create policy "settings匿名查看" on public.settings
  for select to anon, authenticated using (true);

drop policy if exists "settings登录增删改" on public.settings;
create policy "settings登录增删改" on public.settings
  for all to authenticated using (true) with check (true);

-- ---------- 默认服务项目（表为空时才插入，重复运行不会产生重复数据） ----------
insert into public.services (name, description, price, sort_order)
select * from (values
  ('笔记本清灰', '拆机除尘、换硅脂、清理风扇', '一口价89元', 1),
  ('系统重装/优化', '装系统、装驱动、清理提速', '9.9 元', 2),
  ('硬件升级', '加内存、换固态硬盘', '工费 19.9元', 3),
  ('二手回收', '上门检测、当面估价、当面付款', '按成色估价', 4),
  ('二手售卖', '附验机报告 + 3 天保修', '按行情定价', 5)
) as v(name, description, price, sort_order)
where not exists (select 1 from public.services);

-- ---------- 默认网站设置 ----------
insert into public.settings (key, value) values
  ('hero_title', '校园HiA工作室电脑维修 · 预约与报价'),
  ('hero_subtitle', '明码标价 · 上门/校内取送 · 修后保修'),
  ('contact', '电话 18896094889 · 微信 HiATEAM'),
  ('footer', '© 校园HiAHardware工作室 · 有问题随时联系')
on conflict do nothing;
