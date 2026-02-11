Backend AI Integration
======================

The Spring Boot backend integrates with Ollama for AI-powered chat functionality.

Overview
--------

The application uses **Spring AI** to connect with **Ollama**, a local LLM (Large Language Model) server. This enables:

* Real-time AI chat responses
* Server-Sent Events (SSE) streaming
* Local LLM execution (no external API calls)
* Customizable AI models

Technology Stack
----------------

**Spring AI**

Spring AI provides abstractions for AI model integration:

* **ChatModel**: Interface for chat completions
* **Prompt**: Input to the model
* **Generation**: Model response
* **Streaming**: Reactive stream support

**Ollama**

Ollama runs LLMs locally:

* Open-source LLM runner
* Supports various models (Gemma, Llama, etc.)
* REST API for model interaction
* Local execution (privacy, no internet required)

Dependencies
------------

Add to ``build.gradle.kts``:

.. code-block:: kotlin

    dependencies {
        implementation(platform("org.springframework.ai:spring-ai-bom:2.0.0-M2"))
        implementation("org.springframework.ai:spring-ai-starter-model-ollama")
    }

Configuration
-------------

Application Properties
~~~~~~~~~~~~~~~~~~~~~~

Configure Ollama in ``application.properties``:

.. code-block:: properties

    # Ollama server URL
    spring.ai.ollama.base-url=http://localhost:11434
    
    # Model pull strategy
    spring.ai.ollama.init.pull-model-strategy=when_missing
    
    # AI Model selection
    spring.ai.ollama.chat.options.model=gemma3:270m

Model Options
~~~~~~~~~~~~~

Available models:

.. list-table::
   :header-rows: 1

   * - Model
     - Size
     - Use Case
   * - gemma3:270m
     - 270M params
     - Fast responses, simple queries
   * - gemma3:1b
     - 1B params
     - Balanced speed/quality
   * - llama3.2:1b
     - 1B params
     - Alternative model
   * - llama3.2
     - 3B+ params
     - Higher quality, slower

ChatController
--------------

The controller handles AI chat requests:

.. code-block:: java

    @RestController
    @RequestMapping("/chat")
    public class ChatController {
        
        private final ChatModel chatModel;

        public ChatController(ChatModel chatModel) {
            this.chatModel = chatModel;
        }

        @PostMapping(produces = MediaType.TEXT_EVENT_STREAM_VALUE)
        public Flux<String> generate(@RequestBody Map<String, String> request) {
            String prompt = request.get("prompt");
            
            if (prompt == null || prompt.isBlank()) {
                return Flux.just("error: prompt is required");
            }
            
            return chatModel.stream(prompt)
                .concatWithValues("[DONE]");
        }
    }

Key Components:

* **ChatModel**: Injected Spring AI component
* **@PostMapping**: Accepts POST requests
* **produces**: Sets content-type to ``text/event-stream``
* **Flux<String>**: Reactive stream of responses
* **stream(prompt)**: Stream tokens as they're generated
* **concatWithValues**: Append end marker

API Usage
---------

Request
~~~~~~~

.. code-block:: bash

    POST /chat
    Content-Type: application/json

.. code-block:: json

    {
        "prompt": "What are the benefits of electric motorcycles?"
    }

Response
~~~~~~~~

Server-Sent Events stream:

.. code-block:: text

    data: Electric motorcycles offer several benefits:
    
    data: 
    
    data: 1. **Environmental Impact**: Zero emissions during operation
    
    data: 2. **Lower Operating Costs**: Electricity is cheaper than gasoline
    
    data: 3. **Reduced Maintenance**: Fewer moving parts, no oil changes
    
    data: [DONE]

Each ``data:`` line is a separate SSE event. The client should:

1. Open an EventSource connection
2. Listen for ``message`` events
3. Append each chunk to the UI
4. Stop when ``[DONE]`` received

Setup Ollama
------------

Installation
~~~~~~~~~~~~

**macOS/Linux**:

.. code-block:: bash

    curl -fsSL https://ollama.com/install.sh | sh

**Windows**:

Download from https://ollama.com/download

Start Ollama
~~~~~~~~~~~~

.. code-block:: bash

    ollama serve

Default port: 11434

Pull Models
~~~~~~~~~~~

Download the model specified in configuration:

.. code-block:: bash

    ollama pull gemma3:270m

Verify installation:

.. code-block:: bash

    ollama list

Customizing AI Behavior
-----------------------

System Prompt
~~~~~~~~~~~~~

Configure system behavior in application properties:

.. code-block:: properties

    spring.ai.ollama.chat.options.system-prompt=You are a helpful motorcycle shop assistant.

Temperature
~~~~~~~~~~~

Control response creativity (0.0 - 1.0):

.. code-block:: properties

    spring.ai.ollama.chat.options.temperature=0.7

* **0.0**: Deterministic, focused responses
* **0.7**: Balanced creativity
* **1.0**: Maximum creativity

Max Tokens
~~~~~~~~~~

Limit response length:

.. code-block:: properties

    spring.ai.ollama.chat.options.max-tokens=500

Error Handling
--------------

Ollama Not Running
~~~~~~~~~~~~~~~~~~

.. code-block:: java

    @PostMapping(produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    public Flux<String> generate(@RequestBody Map<String, String> request) {
        try {
            String prompt = request.get("prompt");
            if (prompt == null || prompt.isBlank()) {
                return Flux.just("error: prompt is required");
            }
            return chatModel.stream(prompt)
                .concatWithValues("[DONE]");
        } catch (Exception e) {
            return Flux.just("error: AI service unavailable");
        }
    }

Model Not Found
~~~~~~~~~~~~~~~

If the configured model isn't available:

1. Check model name in properties
2. Pull the model: ``ollama pull gemma3:270m``
3. Or change to available model

Performance Considerations
--------------------------

**Model Size**

* Smaller models (270M) are faster but less capable
* Larger models (1B+) are slower but higher quality
* Choose based on response time requirements

**Hardware Requirements**

* **CPU**: Any modern CPU works
* **RAM**: 2GB+ for small models, 8GB+ for larger
* **GPU**: Optional but speeds up inference

**Caching**

Consider implementing response caching for common queries:

.. code-block:: java

    @Cacheable("chat-responses")
    public Flux<String> generate(String prompt) {
        // Check cache first
        // Return cached or generate new
    }

Testing
-------

Manual Test
~~~~~~~~~~~

.. code-block:: bash

    curl -X POST http://localhost:8080/chat \
      -H "Content-Type: application/json" \
      -d '{"prompt":"Hello"}'

Integration Test
~~~~~~~~~~~~~~~~

.. code-block:: java

    @SpringBootTest
    class ChatControllerTest {
        
        @Autowired
        private TestRestTemplate restTemplate;
        
        @Test
        void testChatEndpoint() {
            Map<String, String> request = Map.of("prompt", "Hi");
            ResponseEntity<String> response = restTemplate.postForEntity(
                "/chat", request, String.class
            );
            assertEquals(HttpStatus.OK, response.getStatusCode());
        }
    }

Next Steps
----------

* :doc:`backend-deployment` - Deploy with Ollama
* Ollama Documentation: https://ollama.com/docs
