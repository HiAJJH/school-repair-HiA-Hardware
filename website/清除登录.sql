-- 清除所有登录状态（一键把所有设备的登录都登出）
-- 在 Supabase → SQL Editor 粘贴运行一次
create or replace function public.clear_all_sessions()
returns void
language plpgsql
security definer
as $$
begin
  delete from auth.sessions;
end;
$$;

grant execute on function public.clear_all_sessions() to authenticated;
