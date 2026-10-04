-- ============================================================
-- 群聊系统：消息表 + 文件存储桶
-- 在 Supabase → SQL Editor 粘贴整段运行一次
-- ============================================================

-- 群聊消息表
create table if not exists public.group_messages (
  id uuid primary key default gen_random_uuid(),
  name text not null default '同学',
  type text not null default 'text',   -- text | image | video | voice
  content text,
  created_at timestamptz not null default now()
);

alter table public.group_messages enable row level security;

-- 都能发消息
drop policy if exists "群聊插入" on public.group_messages;
create policy "群聊插入" on public.group_messages
  for insert to anon, authenticated with check (true);

-- 都能看消息
drop policy if exists "群聊查看" on public.group_messages;
create policy "群聊查看" on public.group_messages
  for select to anon, authenticated using (true);

-- 管理员可删除消息（清除群聊记录）
drop policy if exists "群聊删除" on public.group_messages;
create policy "群聊删除" on public.group_messages
  for delete to authenticated using (true);

-- 匿名也可删除（兜底，保证聊天页的清除按钮一定能用）
drop policy if exists "群聊匿名删除" on public.group_messages;
create policy "群聊匿名删除" on public.group_messages
  for delete to anon using (true);

-- 开启实时
alter publication supabase_realtime add table public.group_messages;

-- 文件存储桶（存图片/视频/语音）
insert into storage.buckets (id, name, public) values ('chat', 'chat', true)
on conflict (id) do nothing;

-- 都能上传文件
drop policy if exists "聊天文件上传" on storage.objects;
create policy "聊天文件上传" on storage.objects
  for insert to anon, authenticated with check (bucket_id = 'chat');

-- 都能读取文件
drop policy if exists "聊天文件读取" on storage.objects;
create policy "聊天文件读取" on storage.objects
  for select to anon, authenticated using (bucket_id = 'chat');

-- 称呼唯一表（每个称呼只能被一个人使用，24小时过期）
create table if not exists public.chat_names (
  name text primary key,
  claimed_at timestamptz not null default now()
);
alter table public.chat_names enable row level security;
drop policy if exists "名字查看" on public.chat_names;
create policy "名字查看" on public.chat_names for select to anon, authenticated using (true);
drop policy if exists "名字写入" on public.chat_names;
create policy "名字写入" on public.chat_names for insert to anon, authenticated with check (true);
drop policy if exists "名字更新" on public.chat_names;
create policy "名字更新" on public.chat_names for update to anon, authenticated using (true) with check (true);
