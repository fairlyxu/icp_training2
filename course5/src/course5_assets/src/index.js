/* A simple webapp that authenticates the user with Internet Identity and that
 * then calls the whoami canister to check the user's principal.
 */
import { course5 } from "../../declarations/course5"; 
import { Actor, HttpAgent } from "@dfinity/agent";
import { AuthClient } from "@dfinity/auth-client";

const webapp_id = process.env.WHOAMI_CANISTER_ID;

// The interface of the whoami canister
const webapp_idl = ({ IDL }) => {
  return IDL.Service({ whoami: IDL.Func([], [IDL.Principal], ["query"]) });
};
export const init = ({ IDL }) => {
  return [];
};

// Autofills the <input> for the II Url to point to the correct canister.
document.body.onload = () => {
  let iiUrl;
  if (process.env.DFX_NETWORK === "local") {
    iiUrl = `http://localhost:8000/?canisterId=${process.env.II_CANISTER_ID}`;
  } else if (process.env.DFX_NETWORK === "ic") {
    iiUrl = `https://${process.env.II_CANISTER_ID}.ic0.app`;
  } else {
    iiUrl = `https://${process.env.II_CANISTER_ID}.dfinity.network`;
  }
  //document.getElementById("iiUrl").value = iiUrl; 
}
 
//do_canister_form
document.getElementById("do_canister_form").addEventListener("submit", async (e) => {
  e.preventDefault(); 
  let canister_id = document.getElementById("canister_id").value.toString();
  var index=document.getElementById("opt").selectedIndex; 
  let opt =   document.getElementById("opt").options[index].value; 
  
  if (opt!="#create" && !canister_id) {
    alert("canister id 不能为空")
    return 
  }  
  let res = course5.make_proposal(opt,canister_id) 
  return false;
});


//install_code_form
document.getElementById("install_code_form").addEventListener("submit", async (e) => {
  e.preventDefault(); 
  let install_canister_id = document.getElementById("install_canister_id").value.toString(); 
  let value = document.getElementById("install_file").value.toString(); 
  console.log(value)
  if (!install_canister_id) {
    alert("canister id 不能为空")
    return 
  } 

  if (!value) {
    alert("文件能为空")
    return 
  }  
  let res = course5.make_proposal(opt,canister_id) 
  return false;
});

//make_proposal_form
document.getElementById("make_proposal_form").addEventListener("submit", async (e) => {
  e.preventDefault(); 
  let make_proposal_id = document.getElementById("make_proposal_id").value.toString();
  var index=document.getElementById("make_proposal_opt").selectedIndex; 
  let make_proposal_opt =   document.getElementById("make_proposal_opt").options[index].value; 
  
  if (opt!="#create" && !make_proposal_id) {
    alert("proposal  id 不能为空")
    return 
  }  
  let res = course5.make_proposal(make_proposal_opt,make_proposal_id) 
  return false;
});

//vote_proposal_form
document.getElementById("vote_proposal_form").addEventListener("submit", async (e) => {
  e.preventDefault(); 
  let vote_proposals_id = document.getElementById("vote_proposals_id").value.toString();
  var index=document.getElementById("vote_proposal_opt").selectedIndex; 
  let vote_proposal_opt =   document.getElementById("vote_proposal_opt").options[index].value; 
  
  if ( !vote_proposals_id) {
    alert("proposal  id 不能为空")
    return 
  }  
  let res = course5.vote_proposal(vote_proposals_id,vote_proposal_opt) 
  return false;
});


//del_proposal_form
document.getElementById("del_proposal_form").addEventListener("submit", async (e) => {
  e.preventDefault(); 
  let del_proposals_id = document.getElementById("del_proposals_id").value.toString();
  
  if ( !del_proposals_id) {
    alert("proposal  id 不能为空")
    return 
  }  
  let res = course5.remove_proposal(del_proposals_id) 
  return false;
});
