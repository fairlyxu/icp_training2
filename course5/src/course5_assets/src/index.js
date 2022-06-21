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
  document.getElementById("iiUrl").value = iiUrl;
};
/*
document.getElementById("loginBtn").addEventListener("click", async () => {
  // When the user clicks, we start the login process.
  // First we have to create and AuthClient.
  const authClient = await AuthClient.create();

  // Find out which URL should be used for login.
  const iiUrl = document.getElementById("iiUrl").value;

  // Call authClient.login(...) to login with Internet Identity. This will open a new tab
  // with the login prompt. The code has to wait for the login process to complete.
  // We can either use the callback functions directly or wrap in a promise.
  await new Promise((resolve, reject) => {
    authClient.login({
      identityProvider: iiUrl,
      onSuccess: resolve,
      onError: reject,
    });
  });

  // At this point we're authenticated, and we can get the identity from the auth client:
  const identity = authClient.getIdentity();
  // Using the identity obtained from the auth client, we can create an agent to interact with the IC.
  const agent = new HttpAgent({ identity });
  // Using the interface description of our webapp, we create an actor that we use to call the service methods.
  const webapp = Actor.createActor(webapp_idl, {
    agent,
    canisterId: webapp_id,
  });
  // Call whoami which returns the principal (user id) of the current user.
  const principal = await webapp.whoami();
  // show the principal on the page
  document.getElementById("loginStatus").innerText = principal.toText();
});*/

document.getElementById("loginBtn").addEventListener("click", async () => {

  const authClient = await AuthClient.create();
  const iiUrl = document.getElementById("iiUrl").value;

  authClient.login({
    identityProvider: iiUrl,
    onSuccess: async()=>{
        const identity = await authClient.getIdentity();
        document.getElementById("loginStatus").innerText = identity.getPrincipal().toText();
        document.getElementById("loginBtn").style.display = "none";
        document.getElementById("iiUrl").innerText = iiUrl;
    }
  })
});

document.getElementById("fresh_members").addEventListener("click", async () => {
  console.log("fresh_members")
  let tmpdiv = document.getElementById("all_members");
  tmpdiv.replaceChildren([]); 
  const members = await course4.show_members();
  console.log( mcnShowControllers)
  for(let i = 0 ; i < members.length; i++){
      let post = document.createElement('post');
      post.innerText = members[i];
      let post2 = document.createElement('post2');
      post2.innerText = '\n'
      tmpdiv.appendChild(post);
      tmpdiv.appendChild(post2); 
  }  
})

document.getElementById("fresh_canister").addEventListener("click", async () => {
  let tmpdiv = document.getElementById("all_canisters");
  tmpdiv.replaceChildren([]); 
  const canisters = await mcn.show_canisters(); 
  for(let i = 0 ; i < canisters.length; i++){
      let post = document.createElement('li');
      post.innerText = canisters[i].canister_id + ' & '+ canisters[i].is_restricted + '\n';
      tmpdiv.appendChild(post); 
  }
})