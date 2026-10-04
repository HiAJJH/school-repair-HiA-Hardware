-- ============================================================
-- 在 Supabase 后台 → SQL Editor 里，把下面整段粘贴后点 Run
-- （本脚本可重复运行，不会因已存在而报错）
-- ============================================================

-- 预约订单表
create table if not exists public.orders (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  phone text not null,
  service text not null,
  device text,
  problem text,
  created_at timestamptz not null default now()
);

-- 开启行级安全（保护数据不被随便读取）
alter table public.orders enable row level security;

-- 先删掉旧策略（避免重复运行时报"已存在"错误）
drop policy if exists "允许匿名提交预约" on public.orders;
drop policy if exists "允许登录用户查看" on public.orders;

-- 允许任何访客（未登录）提交预约
create policy "允许匿名提交预约" on public.orders
  for insert to anon with check (true);

-- 仅允许登录用户（管理员）查看数据
create policy "允许登录用户查看" on public.orders
  for select to authenticated using (true);

-- 允许登录用户（管理员）删除数据（用于"清空数据"按钮）
drop policy if exists "允许登录用户删除" on public.orders;
create policy "允许登录用户删除" on public.orders
  for delete to authenticated using (true);
