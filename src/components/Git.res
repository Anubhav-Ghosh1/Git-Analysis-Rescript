// // Define Response Module
// module Response = {
//   type t<'data>
//   @send external json: t<'data> => promise<'data> = "json"
// }

// // Bind fetch API
// @val @scope("globalThis")
// external fetch: string => promise<Response.t<{"login": string, "id": int, "name": string, "avatar_url": string,"followers":int,"following":int,"bio":string,"html_url":string,"public_repos":int,"public_gists":int}>> = "fetch"
// @react.component
// let make = () => {
//     let (username,setUsername) = React.useState(()=>{"Anubhav-Ghosh1"});
//     let (userData,setUserData) = React.useState(()=>{
//         None
//     })
//     let handleOnChange = (e) => {
//         setUsername((_)=>{
//             //Console.log(ReactEvent.Form.target(e)["value"])
//             ReactEvent.Form.target(e)["value"];
//         })
//         Console.log("Value " ++ username);
//     }

//     let fetchData = async () => {
//         let url = `https://api.github.com/users/${username}`
//         let response = await fetch(url)
//         let data = await response->Response.json
//         setUserData((_)=>{
//             Some(data)
//         })
//         data;
//     }

//     let handleOnClick = (_event: JsxEvent.Mouse.t) => {
//         Console.log(fetchData())
//     }
//     <div>
//         <header>
//             {React.string("Git Analysis")}
//         </header>
//         <div>
//         <form onSubmit={(e)=>{
//             ReactEvent.Form.preventDefault(e);
//         }}>
//             <input onChange={handleOnChange} type_="text" placeholder="Enter Github User" name="" id="" />
//             <button onClick={handleOnClick}>{React.string("Search")}</button>
//         </form>
//         </div>

//         // main component
//         <div>
//         // Repos
//             <div>
//                 <div>
//                 // Icon
//                 </div>
//                 <div>
//                     <p>
//                         {React.string("Value")}
//                     </p>
//                     <p>
//                         {React.string("Repos")}
//                     </p>
//                 </div>
//         </div>
//         // Repos
//         </div>

//     </div>
// }

// Define the Response Module
module Response = {
  type t<'data>
  @send external json: t<'data> => promise<'data> = "json"
}
// Define the GitHub User Type
type githubUser = {
  login: string,
  id: int,
  name: string,
  avatar_url: string,
  followers: int,
  following: int,
  bio: string,
  html_url: string,
  public_repos: int,
  public_gists: int,
  location: string,
  twitter_username: string,
  blog: string,
}

// Bind fetch API
@val @scope("globalThis")
external fetch: string => promise<Response.t<githubUser>> = "fetch"

@react.component
let make = () => {
  let (username, setUsername) = React.useState(() => "Anubhav-Ghosh1")
  /*
const checkRequests = () => {
        axios(`https://api.github.com/rate_limit`)
          .then(({ data }) => {
            let {
              rate: { remaining },
            } = data;
    
            // for testing the error msg
            // remaining = 0;
    
            // Normal Toggle Error msg
            setRemainingRequest(remaining);
            if (remaining === 0) {
              alert("Sorry, you have exceeded your hourly rate limit!");
            }
          })
          .catch((err) => console.log(err));
      };
      useEffect(checkRequests, []);

 */

  // State hooks for different pieces of data
  let (login, setLogin) = React.useState(() => "")
  let (name, setName) = React.useState(() => "")
  let (avatarUrl, setAvatarUrl) = React.useState(() => None)
  let (bio, setBio) = React.useState(() => "")
  let (publicRepos, setPublicRepos) = React.useState(() => 0)
  let (location, setLocation) = React.useState(() => "")
  let (twitterUsername, setTwitterUsername) = React.useState(() => "")
  let (blog, setBlog) = React.useState(() => "")
  let (following, setFollowing) = React.useState(() => 0)
  let (followers, setFollowers) = React.useState(() => 0)
  let (gists, setGists) = React.useState(() => 0)
  let (requests, setRequests) = React.useState(() => 0)

  // Handle input change
  let handleOnChange = e => {
    let newValue = ReactEvent.Form.target(e)["value"]
    setUsername(_ => newValue)
  }

  // Fetch data from GitHub API
  let fetchData = async () => {
    let url = `https://api.github.com/users/${username}`
    let response = await fetch(url)
    let data = await response->Response.json

    // Ensure correct data structure and update the state
    switch data {
    | {
        login,
        name,
        avatar_url,
        bio,
        public_repos,
        location,
        twitter_username,
        public_gists,
        blog,
        followers,
        following,
      } =>
      setLogin(_ => login)
      setName(_ => name)
      setAvatarUrl(_ => Some(avatar_url))
      setBio(_ => bio)
      setPublicRepos(_ => public_repos)
      setLocation(_ => location)
      setTwitterUsername(_ => twitter_username)
      setBlog(_ => blog)
      setFollowers(_ => followers)
      setFollowing(_ => following)
      setGists(_ => public_gists)
    | _ => Console.log("Error: unexpected data structure")
    }

    Console.log(data)
  }

  // Handle button click
  let handleOnClick = (_event: JsxEvent.Mouse.t) => {
    ignore(fetchData())
  }

  <div>
    <header className="flex w-full mt-5 mb-5 justify-center">
      <p className="text-4xl font-semibold"> {React.string("Git Analysis")} </p>
    </header>
    <div className="bg-[#f1f5f8] pt-16 w-full flex justify-center">
      <form
        className="md:w-[60%] w-[90%] flex justify-center"
        onSubmit={e => {
          ReactEvent.Form.preventDefault(e)
        }}>
        <input
          onChange={handleOnChange}
          className="w-full border-2 py-2 px-2 rounded-lg rounded-r-none"
          type_="text"
          placeholder="Enter Github User"
          name=""
          id=""
        />
        <button
          className="bg-[#37bcc8] text-white px-2 rounded-lg rounded-l-none hover:bg-[#88ebf2] transition-all ease-in duration-200"
          onClick={handleOnClick}>
          {React.string("Search")}
        </button>
      </form>
    </div>
    // Main component to display fetched data
    <div
      className="bg-[#f1f5f8] lg:pt-0 pt-24 h-screen flex flex-col items-center gap-10 justify-center">
      // Stats
      <div className="flex flex-col md:flex-row gap-5">
        // user follower start
        <div
          className="flex lg:w-fit w-full bg-white py-2 px-5 hover:scale-105 rounded-lg shadow-lg hover:shadow-xl transition-all ease-in duration-200 items-center gap-5">
          <div className="bg-[#e0fcff] flex justify-center items-center rounded-full">
            <svg
              className="w-16 h-16 p-4 text-[#10e7ff]"
              stroke="currentColor"
              fill="currentColor"
              strokeWidth="0"
              viewBox="0 0 640 512"
              height="200px"
              width="200px"
              xmlns="http://www.w3.org/2000/svg">
              <path
                d="M624 208h-64v-64c0-8.8-7.2-16-16-16h-32c-8.8 0-16 7.2-16 16v64h-64c-8.8 0-16 7.2-16 16v32c0 8.8 7.2 16 16 16h64v64c0 8.8 7.2 16 16 16h32c8.8 0 16-7.2 16-16v-64h64c8.8 0 16-7.2 16-16v-32c0-8.8-7.2-16-16-16zm-400 48c70.7 0 128-57.3 128-128S294.7 0 224 0 96 57.3 96 128s57.3 128 128 128zm89.6 32h-16.7c-22.2 10.2-46.9 16-72.9 16s-50.6-5.8-72.9-16h-16.7C60.2 288 0 348.2 0 422.4V464c0 26.5 21.5 48 48 48h352c26.5 0 48-21.5 48-48v-41.6c0-74.2-60.2-134.4-134.4-134.4z"
              />
            </svg>
          </div>
          <div className="flex flex-col text-left gap-2">
            <p className="text-xl font-semibold"> {React.string(Js.Int.toString(following))} </p>
            <p> {React.string("Following")} </p>
          </div> // user follower
        </div>
        // user following list
        <div
          className="flex bg-white py-2 px-5 hover:scale-105 rounded-lg shadow-lg hover:shadow-xl transition-all ease-in duration-200 w-full items-center gap-5">
          <div className="bg-purple-200 flex justify-center items-center rounded-full">
            <svg
              stroke="currentColor"
              fill="none"
              strokeWidth="2"
              viewBox="0 0 24 24"
              strokeLinecap="round"
              strokeLinejoin="round"
              className="w-16 h-16 p-4 text-purple-600"
              height="1em"
              width="1em"
              xmlns="http://www.w3.org/2000/svg">
              <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2" />
              <circle cx="9" cy="7" r="4" />
              <path d="M23 21v-2a4 4 0 0 0-3-3.87" />
              <path d="M16 3.13a4 4 0 0 1 0 7.75" />
            </svg>
          </div>
          <div className="flex flex-col text-left gap-2">
            <p className="text-xl font-semibold"> {React.string(Js.Int.toString(followers))} </p>
            <p> {React.string("Followers")} </p>
          </div>
        </div>
        // user repo
        <div
          className="flex bg-white py-2 px-5 hover:scale-105 rounded-lg shadow-lg hover:shadow-xl transition-all ease-in duration-200 w-full items-center gap-5">
          <div className="bg-[#FFE0F0] flex justify-center items-center rounded-full">
            <svg
              stroke="currentColor"
              fill="currentColor"
              strokeWidth="0"
              viewBox="0 0 12 16"
              className="w-16 h-16 p-4 text-[#ff44a5]"
              height="1em"
              width="1em"
              xmlns="http://www.w3.org/2000/svg">
              <path
                fillRule="evenodd"
                d="M4 9H3V8h1v1zm0-3H3v1h1V6zm0-2H3v1h1V4zm0-2H3v1h1V2zm8-1v12c0 .55-.45 1-1 1H6v2l-1.5-1.5L3 16v-2H1c-.55 0-1-.45-1-1V1c0-.55.45-1 1-1h10c.55 0 1 .45 1 1zm-1 10H1v2h2v-1h3v1h5v-2zm0-10H2v9h9V1z"
              />
            </svg>
          </div>
          <div className="flex flex-col text-left gap-2">
            <p className="text-xl font-semibold"> {React.string(Js.Int.toString(publicRepos))} </p>
            <p> {React.string("Repos")} </p>
          </div>
        </div>
        // user gits
        <div
          className="flex bg-white py-2 px-5 hover:scale-105 rounded-lg shadow-lg hover:shadow-xl transition-all ease-in duration-200 w-full items-center gap-5">
          <div className="bg-[#FFFBEA] flex justify-center items-center rounded-full">
            <svg
              stroke="currentColor"
              fill="currentColor"
              strokeWidth="0"
              viewBox="0 0 12 16"
              className="w-16 h-16 p-4 text-[#ffd931]"
              height="1em"
              width="1em"
              xmlns="http://www.w3.org/2000/svg">
              <path
                fillRule="evenodd"
                d="M7.5 5L10 7.5 7.5 10l-.75-.75L8.5 7.5 6.75 5.75 7.5 5zm-3 0L2 7.5 4.5 10l.75-.75L3.5 7.5l1.75-1.75L4.5 5zM0 13V2c0-.55.45-1 1-1h10c.55 0 1 .45 1 1v11c0 .55-.45 1-1 1H1c-.55 0-1-.45-1-1zm1 0h10V2H1v11z"
              />
            </svg>
          </div>
          <div className="flex flex-col text-left gap-2">
            <p className="text-xl font-semibold"> {React.string(Js.Int.toString(gists))} </p>
            <p> {React.string("Gits")} </p>
          </div>
        </div>
      </div>
      // Stats

      <div
        className="flex rounded-lg flex-col items-center justify-center bg-white h-fit py-10 lg:w-[60%] w-full border-2">
        {switch avatarUrl {
        | Some(avatar_url) =>
          <div className="flex lg:flex-row flex-col">
            <div className="flex lg:flex-col flex-row gap-10 items-center justify-center">
              <div className="flex flex-col items-center gap-10">
                <div className="flex flex-col lg:flex-row items-center gap-5">
                  <img
                    src={avatar_url} className="md:w-40 w-16 rounded-full" alt="Avatar" height="50"
                  />
                  <div className="text-center">
                    <p> {React.string("@" ++ login)} </p>
                    <p> {React.string(name)} </p>
                    <p className="text-wrap"> {React.string(bio)} </p>
                    <div className="flex lg:flew-row flex-col items-center gap-2">
                      <p> {React.string("@ " ++ twitterUsername)} </p>
                      <div className="flex items-center gap-2">
                        <img
                          className="w-4 h-4"
                          src="https://cdn-icons-png.flaticon.com/512/3214/3214746.png"
                          alt=""
                        />
                        <a href={`${blog}`}> {React.string(blog)} </a>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        | None => <p> {React.string("Search for user")} </p>
        }}
      </div>
    </div>
  </div>
}
