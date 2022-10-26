
(* 阅读本文件之前, 请确保你阅读过 `term.ml` `type.ml`. *)

open Base
open Type
[@@@warning "-27"]
[@@@warning "-32"]
[@@@warning "-39"] 

(* 
  本文件中对 Type.Typed.tm 进行类型检查, 方便起见, 简记 Term = Type.Typed
  不 Open Term 是因为构造器会重名, 如 Term.Int 与 Type.Int
 *)
module Term = Typed 
type tm = Term.tm 

(*
  类似我们在动态语义那里做过的, 我们先来做一点小练习.

  我们已经知道运行时错误 true + 3 --> 错误
  类型系统不仅要检查出这种错误, 还要检查出正确的类型, 即:
  当有正确的类型时, 能够给出正确的类型;
  当没有正确的类型时, 报告错误. 例如:
 *)
let example_tm_check_1 : string = "if true then 1 else false end"
let example_ty_result_1 : ty option = None (* 1 和 false 不是相同类型, 因而错误 *)
let example_tm_check_2 : string = "if true then 1 else 0 end"
let example_ty_result_2 : ty option = Some(Int) (* 1 和 0 是 Int, 从而整个项是 Int *)

(* 参考例子, 请你判断下列三项有无正确的类型(各 2 分): *)

let tm_check_1 : string = "if 2 + 1 = 3 then (\\ x:Bool.3) (2<3) else 9-1 end"
let ty_result_1 : ty option = Some(Bool) (* Todo *)
let tm_check_2 : string = "(\\ x : Int. x + 4)(true - false)"
let ty_result_2 : ty option = Some(Bool) (* Todo *)
let tm_check_3 : string = "\\ b : Bool. if b then 2 else 1 + b end"
let ty_result_3 : ty option = Some(Bool) (* Todo *)


(*
  下面实现的 check 函数, check Γ tm = Some ty 
  对应的是 typing judgement, 即 Γ⊢tm:ty 
  如果没有正确的类型, 那么 check Γ tm = None
 *)
let rec check (ctx:ctx) (tm:tm) : ty option =
  match tm with
  | Term.Int(n) -> (
    (*
      -------------------- Ty-Int
      Γ ⊢ Int(n) : Int
     *)
    Some Int
  )
  | Term.Bool(n) -> (
    (*
      仿照 Ty-Int, 写出 Term.bool(n) 的类型检查:

      -------------------- Ty-Bool
      Γ ⊢ Bool(n) : Bool
     *)
    raise Todo.Statics
  )
  
  | Term.Add(t1, t2) -> (
    (*
      根据规则写出实现:

       Γ ⊢ t1 : Int  Γ ⊢ t2 : Int
      ----------------------------- Ty-Add
           Γ ⊢ t1 + t2 : Int
     *)
    raise Todo.Statics
  )
    
  | Term.Sub(t1, t2) -> (
    (*
      请先补充类型规则, 再根据类型规则补全此分支的代码

      ------------------------------------------ Ty-Sub

     *)
    raise Todo.Statics
  )
  | Term.Lt(t1, t2) -> (
    (*
      请先补充类型规则, 再根据类型规则补全此分支的代码

      ------------------------------------------ Ty-Lt

     *)
    raise Todo.Statics
  )
  | Term.Eq(t1, t2) -> (
    (*
      请先补充类型规则, 再根据类型规则补全此分支的代码

      ------------------------------------------ Ty-Eq

     *)
    raise Todo.Statics
  )
  | Term.If(t1, t2, t3) -> (
    (*
      根据规则写出实现:
       Γ ⊢ t1 : Bool  Γ ⊢ t2 : ty2  Γ ⊢ t3 : ty3  ty2=ty3
      ----------------------------------------------------- Ty-If
         Γ ⊢ if t1 then t2 else t3 end : ty2
     *)
    raise Todo.Statics
  )
  | Term.Var(x) -> 
    (*
      根据规则写出实现: 
      ( 提示:你需要使用 Map 相关方法, 你应在 lab-1 中足够熟悉, 亦可参考
        https://ocaml.org/p/base/v0.15.0/doc/Base/Map/index.html )

      -------------- Ty-Var
       Γ, x:T ⊢ x:T

       上述记法来自教材第 4 章, 写成下述形式或许有利于你实现:

        x : T ∈ Γ
      -------------- Ty-Var      
        Γ ⊢ x : T

     *)
    raise Todo.Statics
  | Term.Lam(x, ty1, tm) -> (
    (*
      根据规则写出实现: 
           Γ, x:ty1 ⊢ tm : ty2
      ------------------------------ Ty-Lam
       Γ ⊢ (λx:ty1.tm) : ty1 -> ty2
     *)
    raise Todo.Statics
  )
  | Term.App(t1, t2) -> (
    (*
      根据规则写出实现: 
       Γ ⊢ t1 : ty1->ty2  Γ ⊢ t2 : ty1' ty1=ty1'
      ------------------------------------------ Ty-App
       Γ ⊢ t1 t2 : ty2
     *)
    raise Todo.Statics
  )
  | Term.Fix(bind, ty, body) -> (
    (*
      这一分支是 fix 拓展部分, 请放到最后完成.

             Γ, bind : ty ⊢ body  : ty
      ------------------------------------------- Ty-Fix
       Γ ⊢ (fix bind : ty = body) : ty
      
     *)
    raise Todo.Fixpoint
  )
  
(*
  接下来的任务, 请前往 `todo.ml` 领取.
  另外, 至此你完成了 lab-2 的基础部分, 解锁了 check 指令.
  关于 check 指令以及先前你可能错过的 let 与 eval 指令,
  请阅读 `test.ml` 获取相关信息, 这将有助于你继续完成接下来的实验.
 *)