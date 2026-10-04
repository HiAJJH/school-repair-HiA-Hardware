-- ============================================================
-- 在线联系（聊天）消息表
-- 在 Supabase → SQL Editor 粘贴整段运行一次
-- ============================================================

create table if not exists public.messages (
  id uuid primary key default gen_random_uuid(),
  name text not null default '同学',
  content text not null,
  is_admin boolean not null default false,
  is_read boolean not null default false,
  created_at timestamptz not null default now()
);

alter table public.messages enable row level security;

-- 匿名可发消息（客户留言）
drop policy if exists "messages匿名插入" on public.messages;
create policy "messages匿名插入" on public.messages
  for insert to anon with check (true);

-- 匿名和登录都能查看消息
drop policy if exists "messages查看" on public.messages;
create policy "messages查看" on public.messages
  for select to anon, authenticated using (true);

-- 登录可更新（标记已读、回复）
drop policy if exists "messages登录更新" on public.messages;
create policy "messages登录更新" on public.messages
  for update to authenticated using (true) with check (true);

-- 开启实时推送
alter publication supabase_realtime add table public.messages;
