-- 允许管理员删除消息（用于"一天自动清除聊天记录"）
-- 在 Supabase → SQL Editor 粘贴运行一次
drop policy if exists "messages登录删除" on public.messages;
create policy "messages登录删除" on public.messages
  for delete to authenticated using (true);
